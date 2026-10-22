# Can this Minecraft server run 24/7 using GitHub only?

## Answer

No—not on GitHub's hosted infrastructure alone. GitHub can store the project and run short automation jobs, but it does not provide a permanent game-server process, persistent server disk, or a public Java/Bedrock game endpoint.

## Verified GitHub limits

- GitHub-hosted Actions jobs have a maximum execution time of **6 hours per job**. A job is cancelled when it reaches the limit.
  Source: https://docs.github.com/en/actions/reference/limits
- Standard GitHub-hosted runners can be free for public repositories, but this does not remove the per-job timeout or turn Actions into a persistent hosting service.
  Source: https://docs.github.com/en/actions/reference/runners/github-hosted-runners
- Personal GitHub Free accounts include a Codespaces quota documented as 120 compute hours per month and 15 GB-month storage. Codespaces stop after inactivity and have a hard maximum lifetime of 12 hours, even while active.
  Sources:
  - https://docs.github.com/en/billing/concepts/product-billing/github-codespaces
  - https://docs.github.com/en/codespaces/about-codespaces/understanding-the-codespace-lifecycle
- Codespaces port forwarding is for **TCP** ports. A typical Bedrock listener uses **UDP** (usually port 19132), so Codespaces public port forwarding cannot provide the normal Java + Bedrock crossplay endpoint needed here.
  Source: https://docs.github.com/en/codespaces/developing-in-a-codespace/forwarding-ports-in-your-codespace
- GitHub Pages hosts static sites; it does not run a Minecraft server process or arbitrary backend service.
  Source: https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site
- GitHub's product terms restrict using GitHub-hosted Actions for activities unrelated to building, testing, deploying, or publishing the associated software project, and prohibit disproportionate burden on GitHub servers. Do not chain or repeatedly relaunch Actions jobs to evade time limits as a hosting workaround.
  Source: https://docs.github.com/en/site-policy/github-terms/github-terms-for-additional-products-and-features

## Realistic $0 paths

### A. GitHub only
Use GitHub for configuration, scripts, documentation and CI checks. This path does **not** host a live multiplayer server. In this repository, the supported GitHub-only workflow can download Paper/Geyser/Floodgate, smoke-test Paper under Java 25 until the EULA gate, and publish a short-lived software artifact. It does not expose a game port or preserve a world between runner jobs.
See: https://github.com/hsudais201-ops/Minecraft/actions

### B. GitHub plus a device you already own
If you have a compatible computer that can stay powered on and connected, you can run Paper (or the official Java server) directly on that device. GitHub remains the source repository, but the device—not GitHub—hosts the world. This uses your existing electricity and internet, and actual 24/7 availability depends on your device, network, and any router/ISP restrictions. A Chromebook may be too limited or may not support the necessary networking easily.

For Java + Bedrock crossplay on a host you control, use compatible versions of Paper, Geyser, and Floodgate. Typical default ports are Java TCP 25565 and Bedrock UDP 19132. Keep Java online authentication enabled and enable a whitelist.

### C. A free external hosting service
A provider may offer a limited free plan, but availability, sleep behavior, resource caps, and terms vary. Do not assume it offers unlimited 24/7 uptime; check the provider's current terms first.

## Safety
- Do not add billing details or turn on paid resources as a workaround.
- Do not commit passwords, API tokens, SSH private keys, EULA acceptance files, live world data, or server credentials.
- Do not promise friends an always-online IP until an actual host is running and both Java and Bedrock connections are tested.
- Do not use Codespaces quotas or repeated Actions runs as a way to bypass hosting limits; the environment is temporary and its published forwarding is TCP-only.
