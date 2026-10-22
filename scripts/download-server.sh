#!/usr/bin/env bash
set -euo pipefail

# Run this on a Linux machine that you control, not in GitHub Actions.
# Usage: ./scripts/download-server.sh <minecraft-version> [target-directory]

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <minecraft-version> [target-directory]" >&2
  echo "Example: $0 1.21.11" >&2
  exit 2
fi

MC_VERSION="$1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${2:-$ROOT_DIR/server-runtime}"
PLUGIN_DIR="$TARGET_DIR/plugins"
USER_AGENT="minecraft-crossplay-survival/1.0 (https://github.com/hsudais201-ops/Minecraft)"

for tool in curl jq sha256sum; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required tool: $tool" >&2
    echo "Install curl, jq, and sha256sum using your Linux distribution's package manager." >&2
    exit 1
  fi
done

mkdir -p "$PLUGIN_DIR"

download_checked() {
  local name="$1"
  local url="$2"
  local sha="$3"
  local destination="$4"
  local temp_file

  if [[ -z "$sha" || "$sha" == "null" ]]; then
    echo "No SHA-256 checksum provided for $name; refusing unverified download." >&2
    return 1
  fi

  temp_file="$(mktemp "${destination}.tmp.XXXXXX")"
  if ! curl --fail --location --silent --show-error \
      --retry 2 --retry-delay 2 \
      -H "User-Agent: $USER_AGENT" \
      --output "$temp_file" "$url"; then
    rm -f "$temp_file"
    return 1
  fi

  if ! printf '%s  %s\n' "$sha" "$temp_file" | sha256sum --check --status; then
    rm -f "$temp_file"
    echo "Checksum verification failed for $name; download discarded." >&2
    return 1
  fi

  mv -f "$temp_file" "$destination"
  echo "Downloaded and verified: $name"
}

echo "Looking for a stable Paper build for Minecraft $MC_VERSION..."
PAPER_BUILDS="$(curl --fail --location --silent --show-error \
  -H "User-Agent: $USER_AGENT" \
  "https://fill.papermc.io/v3/projects/paper/versions/$MC_VERSION/builds")"

PAPER_URL="$(printf '%s' "$PAPER_BUILDS" | jq -r 'first(.[] | select(.channel == "STABLE") | .downloads["server:default"].url) // empty')"
PAPER_SHA="$(printf '%s' "$PAPER_BUILDS" | jq -r 'first(.[] | select(.channel == "STABLE") | .downloads["server:default"].checksums.sha256) // empty')"

if [[ -z "$PAPER_URL" || -z "$PAPER_SHA" ]]; then
  echo "No stable Paper build/checksum found for Minecraft $MC_VERSION." >&2
  echo "Choose a version with a stable Paper build at https://papermc.io/downloads/paper" >&2
  exit 1
fi

download_checked "Paper server" "$PAPER_URL" "$PAPER_SHA" "$TARGET_DIR/paper.jar"

download_geyser_plugin() {
  local project="$1"
  local filename="$2"
  local metadata url sha

  metadata="$(curl --fail --location --silent --show-error \
    -H "User-Agent: $USER_AGENT" \
    "https://download.geysermc.org/v2/projects/$project/versions/latest/builds/latest")"
  url="https://download.geysermc.org/v2/projects/$project/versions/latest/builds/latest/downloads/spigot"
  sha="$(printf '%s' "$metadata" | jq -r '.downloads.spigot.sha256 // empty')"

  download_checked "$filename" "$url" "$sha" "$PLUGIN_DIR/$filename"
}

download_geyser_plugin "geyser" "Geyser-Spigot.jar"
download_geyser_plugin "floodgate" "floodgate-spigot.jar"

# Create the initial configuration only when none exists; never overwrite a user's edits.
if [[ ! -e "$TARGET_DIR/server.properties" ]]; then
  cp "$ROOT_DIR/config/server.properties" "$TARGET_DIR/server.properties"
  echo "Copied starter server.properties; review it before the first start."
else
  echo "Kept existing server.properties unchanged."
fi

cat <<EOF

Files are prepared in: $TARGET_DIR

This script does NOT accept the Minecraft EULA and does NOT start the server.
Review the EULA yourself, then use scripts/start-server.sh when ready.
Geyser and Floodgate must be compatible with your selected Paper/Minecraft version.
EOF
