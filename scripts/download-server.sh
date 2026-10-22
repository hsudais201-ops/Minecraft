#!/usr/bin/env bash
set -euo pipefail

# Download the official Mojang Minecraft Java 1.21.11 server JAR.
# Usage: ./scripts/download-server.sh [target-directory]

if [[ $# -gt 1 ]]; then
  echo "Usage: $0 [target-directory]" >&2
  exit 2
fi

MC_VERSION="1.21.11"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${1:-$ROOT_DIR/server-runtime}"
USER_AGENT="minecraft-java-vanilla-server/1.0 (https://github.com/hsudais201-ops/Minecraft)"

for tool in curl jq sha1sum; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required tool: $tool" >&2
    echo "Install curl, jq, and sha1sum using your Linux distribution's package manager." >&2
    exit 1
  fi
done

mkdir -p "$TARGET_DIR"

MANIFEST_URL="https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
MANIFEST="$(curl --fail --location --silent --show-error \
  --retry 2 --retry-delay 2 \
  -H "User-Agent: $USER_AGENT" "$MANIFEST_URL")"

META_URL="$(printf '%s' "$MANIFEST" | jq -r --arg version "$MC_VERSION" '.versions[] | select(.id == $version) | .url' | head -n 1)"
META_SHA1="$(printf '%s' "$MANIFEST" | jq -r --arg version "$MC_VERSION" '.versions[] | select(.id == $version) | .sha1' | head -n 1)"

if [[ -z "$META_URL" || -z "$META_SHA1" || "$META_URL" == "null" || "$META_SHA1" == "null" ]]; then
  echo "Minecraft Java $MC_VERSION was not found in Mojang's version manifest." >&2
  exit 1
fi

META_FILE="$(mktemp "$TARGET_DIR/version-meta.json.tmp.XXXXXX")"
SERVER_FILE="$(mktemp "$TARGET_DIR/server.jar.tmp.XXXXXX")"
cleanup() { rm -f "$META_FILE" "$SERVER_FILE"; }
trap cleanup EXIT

curl --fail --location --silent --show-error \
  --retry 2 --retry-delay 2 \
  -H "User-Agent: $USER_AGENT" --output "$META_FILE" "$META_URL"

if ! printf '%s  %s\n' "$META_SHA1" "$META_FILE" | sha1sum --check --status; then
  echo "Mojang version metadata SHA-1 verification failed." >&2
  exit 1
fi

SERVER_URL="$(jq -r '.downloads.server.url // empty' "$META_FILE")"
SERVER_SHA1="$(jq -r '.downloads.server.sha1 // empty' "$META_FILE")"
if [[ -z "$SERVER_URL" || -z "$SERVER_SHA1" ]]; then
  echo "Mojang metadata does not provide the official server download and checksum." >&2
  exit 1
fi

echo "Downloading official Minecraft Java $MC_VERSION server..."
curl --fail --location --silent --show-error \
  --retry 2 --retry-delay 2 \
  -H "User-Agent: $USER_AGENT" --output "$SERVER_FILE" "$SERVER_URL"

if ! printf '%s  %s\n' "$SERVER_SHA1" "$SERVER_FILE" | sha1sum --check --status; then
  echo "Official Minecraft server JAR SHA-1 verification failed; download discarded." >&2
  exit 1
fi

mv -f "$SERVER_FILE" "$TARGET_DIR/server.jar"
rm -f "$META_FILE"
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

Prepared official Minecraft Java $MC_VERSION server files in: $TARGET_DIR
Edition: Java only
Server software: Official Mojang vanilla server
Checksum: verified against Mojang's version manifest

This script does NOT start the server or accept the Minecraft EULA.
Read https://www.minecraft.net/en-us/eula, and change eula=false to
eula=true yourself only if you agree with the EULA.
EOF
