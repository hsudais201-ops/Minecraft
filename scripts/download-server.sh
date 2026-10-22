#!/usr/bin/env bash
set -euo pipefail

# Prepare a Paper Java Edition server. This script does not start it.
# Usage: ./scripts/download-server.sh <minecraft-version> [target-directory]

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <minecraft-version> [target-directory]" >&2
  echo "Example: $0 1.21.11" >&2
  exit 2
fi

MC_VERSION="$1"
if [[ ! "$MC_VERSION" =~ ^[0-9]+(\.[0-9]+){1,2}$ ]]; then
  echo "Minecraft version must look like 1.21.11." >&2
  exit 2
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${2:-$ROOT_DIR/server-runtime}"
USER_AGENT="minecraft-java-server/1.0 (https://github.com/hsudais201-ops/Minecraft)"

for tool in curl jq sha256sum; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required tool: $tool" >&2
    echo "Install curl, jq, and sha256sum using your Linux distribution's package manager." >&2
    exit 1
  fi
done

mkdir -p "$TARGET_DIR"

echo "Looking for a stable Paper Java Edition build for Minecraft $MC_VERSION..."
PAPER_BUILDS="$(curl --fail --location --silent --show-error \
  -H "User-Agent: $USER_AGENT" \
  "https://fill.papermc.io/v3/projects/paper/versions/$MC_VERSION/builds")"

PAPER_URL="$(printf '%s' "$PAPER_BUILDS" | jq -r 'first(.[] | select(.channel == "STABLE") | .downloads["server:default"].url) // empty')"
PAPER_SHA="$(printf '%s' "$PAPER_BUILDS" | jq -r 'first(.[] | select(.channel == "STABLE") | .downloads["server:default"].checksums.sha256) // empty')"

if [[ -z "$PAPER_URL" || -z "$PAPER_SHA" ]]; then
  echo "No stable Paper build/checksum found for Minecraft $MC_VERSION." >&2
  echo "Check https://papermc.io/downloads/paper and choose a supported stable version." >&2
  exit 1
fi

TEMP_FILE="$(mktemp "$TARGET_DIR/paper.jar.tmp.XXXXXX")"
cleanup() { rm -f "$TEMP_FILE"; }
trap cleanup EXIT

curl --fail --location --silent --show-error \
  --retry 2 --retry-delay 2 \
  -H "User-Agent: $USER_AGENT" \
  --output "$TEMP_FILE" "$PAPER_URL"

if ! printf '%s  %s\n' "$PAPER_SHA" "$TEMP_FILE" | sha256sum --check --status; then
  echo "Paper SHA-256 verification failed; downloaded file discarded." >&2
  exit 1
fi

mv -f "$TEMP_FILE" "$TARGET_DIR/paper.jar"
trap - EXIT

if [[ ! -e "$TARGET_DIR/server.properties" ]]; then
  cp "$ROOT_DIR/config/server.properties" "$TARGET_DIR/server.properties"
  echo "Copied starter server.properties."
else
  echo "Kept existing server.properties unchanged."
fi

if [[ ! -e "$TARGET_DIR/eula.txt" ]]; then
  printf '%s\n' 'eula=false' > "$TARGET_DIR/eula.txt"
  echo "Created eula.txt with eula=false."
else
  echo "Kept existing eula.txt unchanged."
fi

cat <<EOF

Prepared Java Edition server files in: $TARGET_DIR
Minecraft version: $MC_VERSION
Server software: Paper (Java Edition only)
Checksum: verified

This script does NOT start the server or accept the Minecraft EULA.
Read https://www.minecraft.net/en-us/eula, and change eula=false to
eula=true yourself only if you agree with the EULA.
EOF
