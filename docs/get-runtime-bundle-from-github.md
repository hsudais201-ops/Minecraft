# Prepare a temporary runtime bundle using GitHub Actions

This workflow downloads official Paper, Geyser-Spigot, and Floodgate-Spigot files on a GitHub-hosted runner, verifies SHA-256 checksums when provided by the download APIs, and makes a temporary artifact that you can download.

**It does not run a live multiplayer server.** GitHub Actions is temporary automation; the artifact expires after 3 days. It is useful for moving the software to a computer you control, not for 24/7 hosting.

## Run it from a phone

1. Open the repository's **Actions** tab:
   https://github.com/hsudais201-ops/Minecraft/actions
2. Select **Prepare Minecraft crossplay runtime**.
3. Tap **Run workflow**.
4. Keep the default Minecraft version `26.3` for the latest Geyser-supported Java protocol, or use another version only if you understand the compatibility implications.
5. Wait for the workflow to finish successfully.
6. Open the completed run, scroll to **Artifacts**, and download `minecraft-crossplay-runtime-26.3` (or the version you selected). The artifact expires after 3 days.
7. Extract it on the computer that will host the game server. Keep the included `SHA256SUMS` manifest with the files.

## Start on your own Linux host

1. Install the Java version Paper requires for the chosen Minecraft version. Paper's current guidance lists Java 25 for Minecraft 26.1 and later:
   https://docs.papermc.io/paper/getting-started/
2. Extract the artifact into a private server directory.
3. Ensure the starter `server.properties` is appropriate. The project template has the whitelist enabled.
4. Read the Minecraft EULA:
   https://www.minecraft.net/en-us/eula
5. The first local launch script writes `eula=false` and exits. Only if you agree with the EULA, edit that file to `eula=true`.
6. Start Paper from its directory using a command such as:

   ```bash
   java -Xms1G -Xmx2G -jar paper.jar --nogui
   ```

7. After the server has generated plugin configuration, configure Geyser's auth type for Floodgate as described in the official documentation:
   - https://geysermc.org/wiki/geyser/setup/
   - https://geysermc.org/wiki/floodgate/
8. Confirm the Bedrock UDP port in Geyser's configuration (commonly 19132) and Java TCP port (commonly 25565). Open only the necessary ports on your host/network.
9. Test from both editions. Do not advertise a public server address until a separate host is reachable from another network.

## Limits

- A GitHub Actions artifact is temporary storage, not a persistent game host.
- A job can fail if the requested Paper version has no stable build.
- Plugin builds may change. Compatibility should be tested before inviting players.
- Continuous uptime requires a separate host that remains powered on and connected.
- Do not add billing details or paid resources to use this workflow.
