#!/usr/bin/env bash
set -euo pipefail

# Run only on the machine that is intended to host the game server.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_DIR="${1:-$ROOT_DIR/server-runtime}"

if ! command -v java >/dev/null 2>&1; then
  echo "Java was not found. Minecraft Java 1.21.11 requires Java 21." >&2
  echo "See https://docs.papermc.io/paper/getting-started/ for Java installation guidance." >&2
  exit 1
fi

if [[ ! -f "$SERVER_DIR/server.jar" ]]; then
  echo "Missing $SERVER_DIR/server.jar" >&2
  echo "Download the official server first: ./scripts/download-server.sh" >&2
  exit 1
fi

cd "$SERVER_DIR"

if [[ ! -f eula.txt ]]; then
  printf '%s\n' 'eula=false' > eula.txt
  echo "Created eula.txt with eula=false."
  echo "Read the Minecraft EULA at https://www.minecraft.net/en-us/eula"
  echo "If and only if you agree, edit eula.txt and change eula=false to eula=true."
  exit 0
fi

if ! grep -qx 'eula=true' eula.txt; then
  echo "The EULA has not been accepted in eula.txt." >&2
  echo "Read https://www.minecraft.net/en-us/eula and change eula=false to eula=true only if you agree." >&2
  exit 1
fi

echo "Starting the official Minecraft Java 1.21.11 server. Type 'stop' in the console to save and shut down safely."
exec java -Xms1G -Xmx2G -jar server.jar --nogui
