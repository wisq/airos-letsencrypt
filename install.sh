#!/bin/sh

host="$1"

set -e

rm -rf tmp/"$host"
mkdir -p tmp/"$host"/etc/persistent/https
cp etc/live/"$host"/privkey.pem tmp/"$host"/etc/persistent/https/server.key
cp etc/live/"$host"/fullchain.pem tmp/"$host"/etc/persistent/https/server.crt
cat tmp/"$host"/etc/persistent/https/server.* > tmp/"$host"/etc/server.pem
scp -r tmp/"$host"/etc "$host":/

exec ssh "$host" "cfgmtd -w -p /etc/; killall lighttpd"
