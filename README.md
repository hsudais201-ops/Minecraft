# Minecraft Crossplay Survival

A GitHub-only project scaffold for a vanilla-style Minecraft Java + Bedrock survival server.

## Honest hosting limitation

GitHub stores the project files and can validate them with GitHub Actions. GitHub Actions runners are temporary jobs, not persistent game servers. This repository alone will **not** provide a continuously running server, a public server IP, or a world that stays online between jobs. Do not use Actions to keep a game server running or to bypass runner limits.

## Planned server stack (when a real host is available)

- **Paper** for a Java Edition server.
- **Geyser** to let Bedrock clients connect to the Java server.
- **Floodgate** for Bedrock-player authentication without requiring each Bedrock player to own Java Edition.
- GitHub for source files, configuration templates, and automated checks.

Paper is close to vanilla but is not identical to the official vanilla server. If strict vanilla mechanics are essential, use the official server and a separately hosted compatible Geyser setup.

## Repository contents

- `config/server.properties` — safe starting configuration.
- `.github/workflows/validate.yml` — checks project files only; it does not launch Minecraft.
- `scripts/check-config.sh` — local configuration validation.

## Setup on a phone

1. Open this repository in GitHub's mobile app or browser.
2. Review the files and workflow under the **Code** tab.
3. Open **Actions** and inspect the **Validate server project** run after a commit.
4. When you later have a permitted Minecraft host, install a supported Java runtime and a server version compatible with your intended client versions.
5. Download server software only from official sources:
   - Paper: https://papermc.io/downloads/paper
   - Geyser: https://geysermc.org/download
   - Floodgate: https://geysermc.org/download
6. Start the server manually on that host, review the Minecraft EULA, and accept it only if you agree.
7. Install compatible Geyser and Floodgate plugins and configure the Bedrock listener.
8. For typical default ports, allow Java on TCP 25565 and Bedrock on UDP 19132 in the host firewall and network firewall.
9. Keep the whitelist enabled until you have added trusted players.

## Free hosting from a phone browser

If you do not have Linux or a virtual phone, see [phone-browser hosting instructions](docs/free-browser-hosting-from-phone.md). This uses a separate free host for the live server; GitHub remains the project repository. Free hosting sleeps/stops while idle and does not promise unlimited always-awake uptime.

## Prepare a downloadable runtime bundle

Use the **Prepare Minecraft crossplay runtime** workflow to download checksum-verified Paper, Geyser, and Floodgate files as a temporary artifact. See [phone-friendly instructions](docs/get-runtime-bundle-from-github.md). This bundle is software only; it does not host a live server.

## Security and backups

- Keep Java `online-mode=true`.
- Keep the whitelist enabled.
- Never commit access tokens, passwords, private SSH keys, or server credentials.
- Back up the world while the server is stopped or using a safe backup method.
- GitHub is not a suitable place to commit live world data, large server JARs, or secrets.

## Cost and uptime

This project does not create paid resources. GitHub Actions usage and limits depend on repository visibility and GitHub's current plan rules. A real multiplayer server requires a separate machine or hosting service; this repository alone cannot provide 24/7 uptime.
