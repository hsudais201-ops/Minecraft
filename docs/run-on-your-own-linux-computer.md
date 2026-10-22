# Run the vanilla Minecraft Java 1.21.11 server on a Linux computer you control

This is the practical way to keep the project files on GitHub while running a real world on a computer you own. GitHub itself will not host the persistent server process.

## Requirements

- A Linux computer you own or are authorized to administer.
- A stable internet connection and a computer that stays powered on while hosting.
- **Java 21** for Minecraft 1.21.11.
- Enough CPU and memory for your expected player count.

## Prepare and start the server

1. Download or clone this repository on the Linux computer.
2. Install `curl`, `jq`, `sha1sum`, and Java 21 using trusted sources and your distribution's package manager.
3. From the repository directory, run:

   ```bash
   bash scripts/download-server.sh
   ```

   The script downloads Mojang's official Minecraft Java 1.21.11 server JAR and verifies it against Mojang's version metadata. It does not install Paper or crossplay plugins.

4. Run:

   ```bash
   bash scripts/start-server.sh
   ```

5. The first run creates `server-runtime/eula.txt` with `eula=false` and exits. Read https://www.minecraft.net/en-us/eula. Only if you agree, change it to `eula=true`.
6. Run the start script again.
7. Keep `online-mode=true`, `white-list=true`, and `enforce-whitelist=true`. Add only trusted players using the server console's whitelist commands.
8. The usual Java port is TCP 25565. Expose that port only if you understand the security impact and your network permits incoming connections.

## Keep it available

- Prevent the host computer from sleeping while you want the server online.
- Back up the world regularly and use the console command `stop` before making manual copies.
- Never commit the server world, JAR, passwords, tokens, SSH keys, or other private data to GitHub.

## If you only have GitHub

The GitHub Actions workflows can validate the project, download the official JAR, and test startup temporarily. They do not create a permanent host, public Minecraft IP, or 24/7 availability. Do not repeatedly relaunch jobs to get around usage limits.
