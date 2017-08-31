# Technical details

## AirOS file layout

Here's the relevant files for TLS on AirOS, as best I can tell:

* `/etc/persistent/https/` seems to be where the certs should be stored.
  * `server.crt` is the X.509 cert, `server.key` is the private key.
* `/etc/https/` consists of symlinks to `/etc/persistent/https/`
* `/etc/server.pem` is what really matters at runtime.
  * It's a concatenated mix of `server.crt` and `server.key`.
  * It seems to be generated only at reboot, so in order to live-update the cert, we must regenerate it ourselves.
  * Lighttpd uses this for all its TLS certificate configuration.

## AirOS processes & commands

* `cfgmtd -w -p /etc/` appears to be required for changes to `/etc/persistent` to persist across reboots.
  * This is aliased to `save` when logged in via SSH, but the alias is not available via direct SSH commands.
* `lighttpd` is the process serving HTTPS.
  * It respawns when killed, so killing it is effectively a restart.
  * It loads certs from `/etc/server.pem` on startup, so it must be restarted (killed) after we copy the certs into place.
