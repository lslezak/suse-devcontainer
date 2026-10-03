#!/bin/sh
set -e

# the NSS module talks to the host Avahi daemon via the mounted socket
zypper --non-interactive --gpg-auto-import-keys install --no-recommends nss-mdns
zypper clean -a
