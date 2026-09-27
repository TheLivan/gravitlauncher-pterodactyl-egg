# GravitLauncher LaunchServer — Pterodactyl egg

Pterodactyl egg and Docker image for running [GravitLauncher](https://github.com/GravitLauncher/Launcher) LaunchServer.

- **Image:** `ghcr.io/thelivan/gravitlauncher-pterodactyl:java25` — Debian 13 (trixie) + [Liberica JDK 25 Full](https://github.com/bell-sw/Liberica/releases) (JavaFX and jmods included, so the launcher build and ProGuard work).
- **Egg:** installs the official `LaunchServerBuild.zip` release from GitHub.

## Install

1. Pterodactyl admin panel → **Nests** → **Import Egg** → upload `egg-gravit-launchserver.json`.
2. Create a server with this egg and set the variables:
   - `GRAVIT_VERSION` — release tag without `v`, e.g. `5.7.12`.
   - `ADDRESS` — `http://IP:PORT` using the server allocation port, or `https://launcher.example.com` behind a reverse proxy. Do not add `/api`.
   - `PROJECTNAME` — your project name.
3. Start the server. `ADDRESS` and `PROJECTNAME` are only used when `LaunchServer.json` is generated on first start.

## Notes

- **Wrong address or 404 on connect:** check `netty.address` (`ws://IP:PORT/api`) and `netty.downloadURL` (`http://IP:PORT/%dirname%/`) in `LaunchServer.json`, then run `build` again.
- **`No space left on device` during `installclient`:** Pterodactyl's `/tmp` is a small tmpfs. The egg startup sets `-Djava.io.tmpdir=/home/container/tmp`. Servers created with an older version of the egg need this startup line:
  ```
  JAVA_OPTS=-Djava.io.tmpdir=/home/container/tmp LISTEN_PORT={{SERVER_PORT}} ./bin/launchserver
  ```
- **Updating:** change `GRAVIT_VERSION` and reinstall. `bin`, `lib`, `launcher-libraries` and `proguard-libraries` are replaced; configs, profiles, updates and modules are kept.
- **Slow downloads (`applyworkspace`, `installclient`):** you can run `applyworkspace` locally and upload `config/MirrorHelper/workspace` and `workspace.json`. Then set `workspaceFile` in `config/MirrorHelper/Config.json` to `/home/container/config/MirrorHelper/workspace.json`.
- The startup command runs through `env` in [`entrypoint.sh`](entrypoint.sh), with no shell, so `&&` and pipes do not work there.

## License

[`entrypoint.sh`](entrypoint.sh) is based on [pterodactyl/yolks](https://github.com/pterodactyl/yolks) (MIT).
