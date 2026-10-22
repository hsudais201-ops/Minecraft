#!/usr/bin/env bash
set -euo pipefail

config_file="${1:-config/server.properties}"
if [[ ! -f "$config_file" ]]; then
  echo "Missing config file: $config_file" >&2
  exit 1
fi

for expected in \
  'gamemode=survival' \
  'online-mode=true' \
  'white-list=true' \
  'enforce-whitelist=true'; do
  if ! grep -Fqx "$expected" "$config_file"; then
    echo "Missing required setting: $expected" >&2
    exit 1
  fi
done

echo "Configuration checks passed: $config_file"
