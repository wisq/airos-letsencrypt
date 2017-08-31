# airos-letsencrypt

Generate and install LetsEncrypt TLS certificates for Ubiquiti AirOS devices.

## Requirements

* A compatible Ubiquiti device running AirOS.
  * HTTPS and SSH must be enabled in the device configuration.
* A system running a compatible (most likely Unix-like) OS.
  * You must have `certbot` installed, ideally 0.17.0 or higher.
  * You'll also need some standard tools: `ssh`, `openssl`.
  * You must be able to SSH into your AirOS devices from this system, using the same domain name as the cert.
    * E.g. if you want your device to be `https://nanobeam.example.org`, then `ssh nanobeam.example.org` must work.
    * Update your `~/.ssh/config` as necessary to make this work.
    * It is strongly recommended to use an SSH agent or passwordless SSH key.
* A DNSimple account, authoritative for the domain you intend to use.
  * You can use other DNS providers supported by `certbot` plugins, but that's up to you to set up.
  * You'll need to install the plugin: `pip install certbot-dns-dnsimple`

## Instructions

1. Copy `conf/dnsimple.ini.example` to `conf/dnsimple.ini` and input an account API access token.
  * Find this under Account settings → Access tokens.
2. Run `./generate.sh fqdn1 fqdn2 fqdn3` (etc.) where each fqdn is the fully-qualified domain name (e.g. `name.example.org`) of one of your nanobeam devices.
  * E.g. `./generate.sh nanobeam1.example.org nanobeam2.example.org`
  * The first time you run this, you will be prompted for various pieces of info.
3. Periodically, run `./renew.sh fqdn1 fqdn2 fqdn3` (etc.) to renew your certificates.
  * It's recommended you run this in a daily cronjob.
  * Certs will not be renewed unless they are near expiry.
  * Note that if you just run `./renew.sh` without any hostnames, certs will be renewed, but will not be installed.

## Caveats

`certbot` uses absolute paths in its renewal configuration files.  If you move this project to a different directory, you'll need to edit `etc/renewal/*.conf` to respect the path change (or create a symlink at the old location).

## Compatibility

Tested with two Ubiquiti Nanobeam 5AC Gen2 devices.  Compatibility with other devices is unknown.

Developed and tested on Debian Linux (sid) using certbot 0.17.0.

## Disclaimer

This software comes with no warranty.  If it somehow bricks your devices, I'm not liable.

The author of this software has no relation to Ubiquiti except as one of their customers.  All trademarks are the property of their respective owners.
