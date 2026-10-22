# Can Minecraft Java 1.21.11 run 24/7 using GitHub only?

## Answer

Not as a reliable, public, always-on Minecraft game server. Java Edition uses TCP, so there is no Bedrock UDP requirement in this project. The remaining problem is that GitHub repository storage and temporary development/CI runners are not a permanent game-hosting service with a conventional public `host:port` endpoint.

## GitHub options and limits

- **GitHub Actions:** Jobs have a maximum execution time and are temporary. The workflow in this repository only downloads Paper 1.21.11 and tests its startup until the EULA gate. It does not keep a server running or create a public game address. Source: https://docs.github.com/en/actions/reference/limits
- **GitHub Codespaces:** A Codespace stops after inactivity and has a maximum lifetime of 12 hours, even if active. Usage is subject to the account's included quota and billing settings. Sources:
  - https://docs.github.com/en/codespaces/about-codespaces/understanding-the-codespace-lifecycle
  - https://docs.github.com/en/billing/concepts/product-billing/github-codespaces
- **Codespaces port forwarding:** Provides forwarded TCP development services through a Codespaces URL. It does not give this repository a permanent Minecraft server or a stable, ordinary public game-server IP:port. Source: https://docs.github.com/en/codespaces/developing-in-a-codespace/forwarding-ports-in-your-codespace
- **GitHub Pages:** Static website hosting; it cannot keep a Java game-server process running. Source: https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site

Do not repeatedly restart GitHub Actions jobs or create extra accounts to evade service limits. Keep GitHub Actions used for normal project build/test tasks.

## What this repository supports

- Target version: **Minecraft Java Edition 1.21.11**
- Server software: Paper, with Java 21
- Verified workflow: downloads the server JAR, checks its SHA-256 digest, and verifies that Java can run it until the EULA gate
- No Geyser/Floodgate, because this project now targets Java Edition only
- No public game endpoint, persistent cloud machine, or 24/7 uptime is created by the GitHub workflows

Run the checks here: https://github.com/hsudais201-ops/Minecraft/actions

## What would make a live server possible?

A real host has to keep the server process running and expose Minecraft's TCP port (normally 25565) to players. This can be a computer you control or a separate hosting provider. A free Codespace may be useful for development experiments, but it is temporary, and using an external raw-TCP tunnel means the setup is no longer GitHub-only.

## Safety

- Do not enable paid cloud resources or add billing details just to try this.
- Do not commit tokens, passwords, SSH keys, EULA acceptance, world data, or private server credentials.
- Keep Java `online-mode=true` and the whitelist enabled.
- Read the Minecraft EULA and accept it manually only if you agree: https://www.minecraft.net/en-us/eula
