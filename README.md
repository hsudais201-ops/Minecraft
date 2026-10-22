# Minecraft Java Survival Server

A GitHub-managed project for a **Java Edition only** survival server, targeting **Minecraft Java 1.21.11**.

## Important hosting limitation

GitHub can store the project and run temporary build/test jobs. It does not provide a permanent Minecraft server process, persistent always-on compute, or a supported public raw-TCP game-server address from this repository alone. The test workflows below verify the server software, but they do not leave a live server running.

The intended stack is **Paper 1.21.11 + Java 21**. Paper is a performance-oriented server and may differ slightly from the official vanilla server. If you require strictly vanilla behavior, use the official Minecraft Java server software on a separate host.

## Files

- `config/server.properties` — safe starter settings with whitelist enabled.
- `scripts/download-server.sh` — downloads a stable Paper build and verifies its SHA-256 checksum.
- `scripts/start-server.sh` — starts Paper only after you manually accept the EULA.
- `.github/workflows/validate.yml` — checks configuration and shell syntax.
- `.github/workflows/github-shell-test.yml` — verifies that GitHub Actions can download and execute Paper 1.21.11 under Java 21 up to its EULA gate.
- `.github/workflows/prepare-runtime.yml` — uploads a temporary software bundle; it expires after 3 days.

## Run the GitHub test

Open [Actions](https://github.com/hsudais201-ops/Minecraft/actions) and run **GitHub Shell and Minecraft Runtime Test**. A successful run means the version's server software passed a temporary startup smoke test—not that a public server is online.

## Prepare server software on a separate Java-capable host

From a Linux computer you control, run:

```bash
bash scripts/download-server.sh 1.21.11
bash scripts/start-server.sh
```

On its first run, the start script creates `eula.txt` with `eula=false` and exits. Read the [Minecraft EULA](https://www.minecraft.net/en-us/eula) and only change it to `eula=true` if you agree. Run the start script again after accepting it.

Paper's guidance lists **Java 21** for Minecraft 1.20 through 1.21.11: https://docs.papermc.io/paper/getting-started/

## Server settings and safety

- Java edition only; no Geyser or Floodgate is installed.
- Keep `online-mode=true`, `white-list=true`, and `enforce-whitelist=true`.
- Default Java port is TCP 25565.
- Do not commit server world data, server JARs, tokens, passwords, SSH keys, or private server data.
- Back up the world regularly and stop the server safely before making manual copies.

## Free hosting reality

For 24/7 multiplayer, a game server needs a host that remains running and exposes a reachable TCP 25565 endpoint. GitHub Actions runner jobs are temporary and Codespaces have usage and lifetime limits; repository files alone cannot provide that. Do not repeatedly restart jobs or create accounts to evade service limits.

See [the hosting limitations and realistic options](docs/24-7-free-hosting-reality.md).
