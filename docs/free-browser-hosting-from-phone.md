# Start a free Java + Bedrock survival server from your phone browser

This guide is for people who do not have Linux or a virtual phone. You can use a mobile browser to configure a server through a hosting control panel. GitHub stays the place for the project files; the host actually runs Minecraft.

## Important limits

The free Falix plan currently lists shared resources (3 GB RAM, one CPU core, and 10 GB storage). Free servers sleep/stop when idle; they are not guaranteed to stay awake continuously. A busy free-hosting pool may queue server starts, and the panel may require activity checks. These limits are controlled by the host, not GitHub.

Official pages:
- Free Minecraft hosting: https://falixnodes.net/free-minecraft-server-hosting
- Create a server: https://kb.falixnodes.net/falix/dashboard/setup/create-server
- Supported software: https://kb.falixnodes.net/falix/dashboard/setup/supported-software
- Geyser cross-play configuration: https://kb.falixnodes.net/minecraft/modifications/software/geysermc

## Phone-browser setup

1. Open https://falixnodes.net/free-minecraft-server-hosting in your phone browser.
2. Create an account and use the free Minecraft server option. The provider currently says payment-card details are not needed for its free plan; never choose Premium or enter payment details just to finish free setup.
3. In the dashboard, choose **Create Server**, then **Free**, then Minecraft.
4. For Java + Bedrock crossplay, look for the **Geyser** software option (Falix documents it as Purpur with Geyser and Floodgate preinstalled). This differs slightly from strict vanilla, but is appropriate for crossplay.
5. Name the server and choose a lowercase domain, then finish creating it.
6. In the server software/options panel, set the game mode to **Survival**, difficulty to **Normal**, and keep the whitelist enabled until you add trusted friends. If those fields are not visible, use the file manager to edit `server.properties`, save, and restart the server.
7. Start the server and wait until the console shows that startup has completed. Open the panel's **Connect** dialog.
8. For Java Edition, use the Java address shown by the panel. For Bedrock Edition, use the separate Bedrock address and port shown by the panel. Do not assume both editions use the same port; use the actual values displayed by the host.
9. Test with one Java player and one Bedrock player. If Bedrock cannot join, check that the Geyser software was selected, Floodgate is present, and use the host's Geyser setup article above.
10. Keep a copy of your world and important settings. Do not upload passwords, private keys, or account tokens into this GitHub repository.

## How the free uptime works

- The host—not GitHub—runs the game server.
- Free servers can sleep/stop while empty and may require you to start them again from the dashboard.
- Do not expect a permanent server process or unlimited always-awake time on the free plan.
- You can share the start page or remote-start feature if the provider offers it for your server, but verify how it works in your panel.
- Avoid paid upgrades if you need to remain at $0.

## If you must use GitHub only

GitHub can store configurations and run short checks. It cannot provide a persistent, publicly reachable Minecraft server by itself. The host is a separate service; no paid GitHub or cloud resource is enabled by following this guide.
