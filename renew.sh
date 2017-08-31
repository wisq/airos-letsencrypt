#!/bin/sh

certbot renew --config-dir etc --work-dir lib --logs-dir log

echo
exec ./install_all.sh "$@"
