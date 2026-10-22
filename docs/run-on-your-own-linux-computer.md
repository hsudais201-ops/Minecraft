# Run this server on a Linux computer you control

This is the practical route if you want to keep all source/configuration on GitHub while running a live world on hardware you already own. GitHub itself will not host the persistent process.

## Before you start

- Use a Linux machine you own or are authorized to administer.
- The machine must have enough RAM/CPU, stay powered on, stay online, and have a network that permits incoming connections.
- 24/7 operation is not literally unlimited: electricity, internet outages, hardware limits, router/ISP policies, and Minecraft/Geyser compatibility still apply.
- Paper is a high-performance Java server that can differ from strict vanilla behavior.
- Check the Java requirement for the exact Minecraft version before running the server. Paper's current guide lists Java 21 for Minecraft 1.20–1.21.11 and Java 25 for 26.1+; verify the latest table at https://docs.papermc.io/paper/getting-started/.

## Prepare the files

1. Clone/download this repository on the Linux computer.
2. Install `curl`, `jq`, `sha256sum`, and the required Java runtime using your distribution's trusted package manager.
3. From the repository directory, run:

   ```bash
   bash scripts/download-server.sh 1.21.11
   ```

   Replace `1.21.11` with a version that has a stable Paper build and supports the client versions you need. The script downloads the stable Paper build and latest Geyser/Floodgate plugin builds, checking SHA-256 checksums where the official endpoints provide them. Plugin compatibility is not guaranteed across all version combinations.

4. Start the server once:

   ```bash
   bash scripts/start-server.sh
   ```

5. Read the Minecraft EULA at https://www.minecraft.net/en-us/eula. The first run creates `server-runtime/eula.txt` with `eula=false` and exits. Only if you agree, edit that file to `eula=true`.
6. Run the start script again. It will start Paper and generate plugin configuration.
7. Stop the server with the console command `stop` before editing files or copying world backups.

## Configure crossplay

1. Make sure both Geyser and Floodgate loaded successfully in the console.
2. Review the generated `server-runtime/plugins/Geyser-Spigot/config.yml`. For this plugin setup, configure Geyser's `auth-type` to `floodgate` as instructed by the official Geyser/Floodgate docs.
3. Keep Java `online-mode=true` and the whitelist enabled. Add only trusted players with the server console's whitelist command.
4. The typical ports are Java TCP 25565 and Bedrock UDP 19132. Confirm the actual Bedrock port in Geyser's config.
5. Only if you understand the security impact and your ISP/router allows it, forward those specific ports to the server computer and allow them in its firewall. Do not expose unrelated services. Some ISPs use carrier-grade NAT and do not allow inbound connections; router changes alone will not fix that.
6. Test locally first, then test from a separate network with both Java and Bedrock clients.

## Keep it available

- Configure the computer not to sleep while hosting, keep it ventilated, and use a stable wired connection when possible.
- Back up the world regularly while the server is stopped, or use a backup tool designed for live Minecraft worlds.
- Keep OS and plugins updated, but back up and check compatibility before updates.
- Do not commit the generated world, server JARs, tokens, SSH keys, or private data to GitHub.

## If you have only GitHub

If no separate computer or hosting runtime is available, GitHub Actions can run checks and create temporary artifacts, but it cannot make this project a supported permanent Minecraft host. Do not repeatedly restart Actions jobs to evade timeouts.
