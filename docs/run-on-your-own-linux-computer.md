# Run Minecraft Java 1.21.11 on a Linux computer you control

This is the practical way to keep the project files on GitHub while running a real world on a computer you own. GitHub itself will not host the persistent game-server process.

## Requirements

- A Linux computer you own or are authorized to administer.
- Enough memory and CPU, a stable internet connection, and a computer that stays powered on.
- **Java 21** for Paper on Minecraft 1.21.11. Verify the current table at https://docs.papermc.io/paper/getting-started/.
- Paper is a performance-oriented Java server and is not identical to the official vanilla server.

## Prepare and start the server

1. Download or clone this repository on the Linux computer.
2. Install `curl`, `jq`, `sha256sum`, and Java 21 using your distribution's trusted package manager.
3. From the repository directory, run:

   ```bash
   bash scripts/download-server.sh 1.21.11
   ```

   The script downloads the stable Paper build for Minecraft 1.21.11 and checks its SHA-256 checksum. It does not install Bedrock crossplay plugins.

4. Run:

   ```bash
   bash scripts/start-server.sh
   ```

5. The first run creates `server-runtime/eula.txt` with `eula=false` and exits. Read https://www.minecraft.net/en-us/eula. Only if you agree, change it to `eula=true`.
6. Run the start script again.
7. Keep `online-mode=true`, `white-list=true`, and `enforce-whitelist=true`. Add only trusted players using the server console's whitelist commands.
8. The usual Java port is TCP 25565. Only expose that port if you understand the security implications and your host/network permits incoming connections.

## Keep it available

- Prevent the host computer from sleeping while you want the server online.
- Back up the world regularly, and stop the server with the console command `stop` before making a manual backup.
- Update Paper carefully after backing up and checking compatibility.
- Never commit the server world, server JAR, secrets, or private server data to GitHub.

## If you only have GitHub

The GitHub Actions workflows in this repository can validate configuration and test Paper 1.21.11 temporarily. They do not create a permanent host, public Minecraft IP, or 24/7 availability. Do not repeatedly relaunch jobs to get around usage limits.
