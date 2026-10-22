#!/usr/bin/env bash
# Interactive helper for a temporary GitHub Codespaces Minecraft server.
# Run with: bash scripts/run-in-codespaces.sh
# This does not bypass GitHub lifetime/quota limits or create a permanent host.

set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

VERSION="1.21.11"
RUNTIME_DIR="$ROOT/server-runtime"
JAR="$RUNTIME_DIR/server.jar"
EULA_FILE="$RUNTIME_DIR/eula.txt"

say() { printf '\n==> %s\n' "$*"; }
fail() { printf '\nERROR: %s\n' "$*" >&2; exit 1; }

say "Minecraft Java $VERSION — GitHub Codespaces helper"
printf 'This runs only while your Codespace is running. It is not 24/7 hosting.\n'
printf 'Minecraft server default port: TCP 25565\n'

command -v java >/dev/null 2>&1 || fail "Java is missing. This Codespace needs Java 21."
JAVA_MAJOR="$(java -version 2>&1 | head -n 1 | grep -oE 'version "[0-9]+' | grep -oE '[0-9]+$' || true)"
[[ "$JAVA_MAJOR" == "21" ]] || fail "Java 21 is required; detected major version: ${JAVA_MAJOR:-unknown}."
command -v curl >/dev/null 2>&1 || fail "curl is missing."
command -v jq >/dev/null 2>&1 || fail "jq is missing."

if [[ ! -f "$JAR" ]]; then
  say "Downloading/verifying the official server JAR"
  bash scripts/download-server.sh
fi
[[ -f "$JAR" ]] || fail "Expected server JAR not found at $JAR."

if [[ ! -f "$EULA_FILE" ]]; then
  mkdir -p "$RUNTIME_DIR"
  printf 'eula=false\n' > "$EULA_FILE"
fi

if ! grep -qx 'eula=true' "$EULA_FILE"; then
  printf '\nMinecraft EULA has not been accepted. The server will NOT start.\n'
  printf 'Read https://www.minecraft.net/en-us/eula\n'
  printf 'Only if you agree, edit %s and change eula=false to eula=true, then run this script again.\n' "$EULA_FILE"
  exit 2
fi

say "Checking the Codespaces forwarded port"
if [[ -n "${CODESPACE_NAME:-}" && -n "${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-}" ]]; then
  printf 'Codespace: %s\n' "$CODESPACE_NAME"
  printf 'Port 25565 forwarding domain: %s\n' "$GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN"
  printf 'After startup, check the Codespaces Ports tab and ensure 25565 is forwarded/public.\n'
  printf 'The forwarded web URL may not be usable as a raw TCP Minecraft address.\n'
else
  printf 'No Codespaces environment variables detected; continuing as a local test only.\n'
fi

say "Starting official vanilla Minecraft server"
cd "$RUNTIME_DIR"
exec java -Xms1G -Xmx2G -jar server.jar nogui
