#!/bin/sh

echo "Installing certs ..."

for host in "$@"; do
	old_serial="`openssl s_client -connect "$host":443 -showcerts < /dev/null 2> /dev/null | openssl x509 -noout -serial`"
	new_serial="`openssl x509 -in etc/live/"$host"/fullchain.pem -noout -serial`"

	if [ "$old_serial" = "$new_serial" ]; then
		echo "Cert on $host is up-to-date."
	else
		echo "Updating cert on $host ..."
		./install.sh "$host" || echo "Failed to install cert on $host."
	fi
done

echo "Done."
