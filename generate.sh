#!/bin/sh

mkdir -p etc lib log

for host in "$@"; do
	certbot certonly --config-dir etc --work-dir lib --logs-dir log \
		--dns-dnsimple --dns-dnsimple-credentials conf/dnsimple.ini \
		-d "$host"
done

echo
exec ./install_all.sh "$@"
