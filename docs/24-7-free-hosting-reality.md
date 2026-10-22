# Can the vanilla Minecraft Java 1.21.11 server run 24/7 using GitHub only?

## Answer

Not as a reliable, public, always-on Minecraft game server. Java Edition uses TCP, so there is no Bedrock UDP requirement. The remaining problem is that GitHub repository storage and temporary CI/development environments do not provide this repository with a permanent Minecraft process, persistent always-on compute, and a supported public game-server address.

## GitHub options and limits

- **GitHub Actions:** Jobs are temporary, have maximum run times, and are designed for repository build/test automation. The workflow here only downloads Mojang's official Java server JAR and tests it until the EULA gate. It does not keep a server running or create a public game address. Source: https://docs.github.com/en/actions/reference/limits
- **GitHub Codespaces:** A Codespace stops after inactivity and has a maximum lifetime of 12 hours, even while active. Usage is subject to the account's included quota and billing settings. Sources:
  - https://docs.github.com/en/codespaces/about-codespaces/understanding-the-codespace-lifecycle
  - https://docs.github.com/en/billing/concepts/product-billing/github-codespaces
- **Codespaces port forwarding:** This is for accessing development services via a Codespaces URL. It does not give this repository a permanent Minecraft server or a conventional stable public Minecraft `host:port` address. Source: https://docs.github.com/en/codespaces/developing-in-a-codespace/forwarding-ports-in-your-codespace
- **GitHub Pages:** Static website hosting; it cannot keep a Java server process running. Source: https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site

Do not repeatedly restart Actions jobs or create extra accounts to evade service limits. Keep GitHub Actions used for normal project build/test tasks.

## What this repository supports

- **Minecraft Java Edition 1.21.11**
- The official Mojang vanilla server JAR
- Java 21
- SHA-1 verification against Mojang's official version metadata
- EULA remains `false` unless you read and accept it yourself
- No public game endpoint, persistent cloud machine, or 24/7 uptime is created by the workflows

Open the [Actions page](https://github.com/hsudais201-ops/Minecraft/actions) to inspect the latest tests and download the short-lived runtime artifact.

## What would make a live server possible?

A real host must keep the server process running and expose Minecraft Java's TCP port (normally 25565) to players. That means using a computer you control or a separate hosting provider. A free Codespace may help with development experiments, but it is temporary, and a third-party raw-TCP tunnel means the setup is no longer GitHub-only.

## Safety

- Do not enable paid cloud resources or add billing details just to try this.
- Do not commit tokens, passwords, SSH keys, world data, or private server credentials.
- Keep `online-mode=true` and the whitelist enabled.
- Read the Minecraft EULA and accept it manually only if you agree: https://www.minecraft.net/en-us/eula
