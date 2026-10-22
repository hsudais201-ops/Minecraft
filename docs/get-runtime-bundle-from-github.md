# Prepare a vanilla Minecraft Java 1.21.11 runtime bundle with GitHub Actions

This workflow downloads the **official Mojang vanilla server JAR** for Minecraft Java 1.21.11, verifies the server and version metadata checksums, tests startup without accepting the EULA, and uploads a temporary artifact.

**It does not host a live server.** The artifact expires after 3 days and is only the software needed to run a server on a separate host.

## Run it from a phone

1. Open the repository's [Actions tab](https://github.com/hsudais201-ops/Minecraft/actions).
2. Select **Prepare Vanilla Minecraft Java 1.21.11 Runtime**.
3. Tap **Run workflow**.
4. Wait for the workflow to finish.
5. Open the completed run and download the artifact named `minecraft-vanilla-java-1.21.11`.

## Start on a computer you control

Minecraft 1.21.11 uses Java 21. Install Java 21 from a trusted source on the target machine.

1. Extract the downloaded files into a private server folder.
2. Read the Minecraft EULA: https://www.minecraft.net/en-us/eula
3. The artifact includes `eula.txt` set to `eula=false`. Only if you agree with the EULA, change it to `eula=true`.
4. Start the server from the extracted folder:

   ```bash
   java -Xms1G -Xmx2G -jar server.jar --nogui
   ```

5. Keep `online-mode=true` and the whitelist enabled. Minecraft Java's default server port is TCP 25565.

## Limits

- The artifact is not a running server and has no public game IP.
- The workflow does not accept the EULA.
- A live server needs a separate host that remains running and can expose TCP 25565.
- Do not enable paid resources or add billing details to run this workflow.
