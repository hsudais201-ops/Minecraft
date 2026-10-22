# Prepare a Minecraft Java 1.21.11 runtime bundle with GitHub Actions

This workflow downloads the official stable Paper build for the requested Minecraft Java version, verifies its SHA-256 checksum, performs a short startup test, and makes a temporary artifact.

**It does not host a live server.** The artifact expires after 3 days and is intended to transfer software to a separate host.

## Run it from a phone

1. Open the repository's [Actions tab](https://github.com/hsudais201-ops/Minecraft/actions).
2. Select **Prepare Minecraft Java 1.21.11 Runtime**.
3. Tap **Run workflow**.
4. Keep the default version `1.21.11`.
5. Wait for the workflow to finish.
6. Open the completed run and download the artifact named `minecraft-java-runtime-1.21.11`.

## Start on a host you control

Paper lists Java 21 for Minecraft 1.20 through 1.21.11. Confirm requirements at https://docs.papermc.io/paper/getting-started/.

1. Extract the downloaded files into a private server directory.
2. Read the Minecraft EULA: https://www.minecraft.net/en-us/eula
3. The artifact includes `eula.txt` containing `eula=false`. Only if you agree with the EULA, change it to `eula=true`.
4. Start Paper from the extracted directory:

   ```bash
   java -Xms1G -Xmx2G -jar paper.jar --nogui
   ```

5. Keep `online-mode=true` and the whitelist enabled. The default Java server port is TCP 25565.

## Limits

- An artifact is not a running server or public game IP.
- The workflow does not accept the EULA.
- A live server needs a separate host that remains running and can expose TCP 25565.
- Don't add paid resources or billing details to run this workflow.
