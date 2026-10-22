# Minecraft Vanilla Java 1.21.11 Survival Server

This repository prepares and tests the **official Minecraft Java Edition 1.21.11 vanilla server**. Bedrock Edition is not supported by this project.

## Honest hosting limitation

GitHub can store the project and run temporary download/test jobs. It does not provide a permanent Minecraft server process, persistent always-on compute, or a supported public game-server endpoint through this repository alone. CI tests do not leave a live server online and do not create an IP.

## Files

- `config/server.properties` — survival starter settings; whitelist enabled.
- `scripts/download-server.sh` — downloads Mojang's official 1.21.11 server JAR and verifies it against Mojang's version metadata.
- `scripts/start-server.sh` — starts the server only after you manually accept the Minecraft EULA.
- `scripts/run-in-codespaces.sh` — command-file helper for starting the server inside a configured Codespace after EULA acceptance.
- `.github/workflows/validate.yml` — checks configuration and shell syntax.
- `.github/workflows/github-shell-test.yml` — tests Java 21 + official server startup through the EULA gate.
- `.github/workflows/prepare-runtime.yml` — uploads a temporary server software artifact that expires after 3 days.

## Run the GitHub test

Open [Actions](https://github.com/hsudais201-ops/Minecraft/actions) and select **GitHub Shell and Minecraft Runtime Test**. Success means the official server JAR ran until the EULA check. It does not mean there is a live public server.

## Experimental GitHub Codespaces trial

This repository includes `.devcontainer/devcontainer.json` for a **temporary Codespaces experiment**. It selects Java 21, installs the download dependencies, downloads the verified official server JAR while leaving `eula=false`, and asks Codespaces to forward port TCP 25565 publicly.

1. Open this repository on GitHub, tap **Code → Codespaces → Create codespace on main**. Check your Codespaces billing/quota first; do not enable paid overages.
2. When the Codespace finishes building, read the [Minecraft EULA](https://www.minecraft.net/en-us/eula). **Only if you agree**, change `server-runtime/eula.txt` from `eula=false` to `eula=true`.
3. In the Codespaces terminal, run `bash scripts/start-server.sh`.
4. Open the **Ports** panel and confirm port `25565` is forwarded and marked **Public**.

**Important:** this is only a test path, not a verified public Minecraft address. Codespaces exposes forwarded services through a generated `app.github.dev` URL and does not guarantee that a normal Minecraft Java client can use that URL as a raw TCP game endpoint. If the client cannot connect, a separate TCP tunneling service or a host that directly exposes TCP 25565 would be required. A Codespace also stops at its maximum lifetime, so it cannot provide a guaranteed 24/7 server.

## Prepare server software on a host

On a Linux host you control, run:

```bash
bash scripts/download-server.sh
bash scripts/start-server.sh
```

Minecraft 1.21.11 requires Java 21. The first start creates `server-runtime/eula.txt` with `eula=false` and exits. Read the [Minecraft EULA](https://www.minecraft.net/en-us/eula); only if you agree, change it to `eula=true`, then run the start script again.

## Survival and security

- Official vanilla server software; no Paper, Geyser, or Floodgate plugins.
- Keep `online-mode=true`, `white-list=true`, and `enforce-whitelist=true`.
- The default Java game port is TCP 25565.
- Back up world data regularly.
- Never commit a world folder, server JAR, API tokens, passwords, SSH keys, or private server data.

## Free hosting reality

For multiplayer, a host has to keep the server process running and expose TCP 25565 to players. GitHub Actions runners are temporary, and Codespaces have usage/lifetime limits. Repository files alone cannot provide a live 24/7 server. Do not repeatedly restart jobs or create extra accounts to evade limits.

See [GitHub-only hosting limitations](docs/24-7-free-hosting-reality.md).
