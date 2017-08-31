#!/bin/sh

certbot renew --config-dir etc --work-dir lib --logs-dir log

echo
exec ./copy.sh "$@"
