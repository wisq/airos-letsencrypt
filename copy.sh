#!/bin/sh

echo "Copying certs ..."
echo

for host in "$@"; do
	old_serial="`openssl s_client -connect "$host":443 -showcerts < /dev/null 2> /dev/null | openssl x509 -noout -serial`"
	new_serial="`openssl x509 -in etc/live/"$host"/fullchain.pem -noout -serial`"

	if [ "$old_serial" = "$new_serial" ]; then
		echo "Cert on "$host" is up-to-date."
	else
		echo
		echo "Updating certs on "$host" ..."
		rm -rf tmp/"$host"
		mkdir -p tmp/"$host"/etc/persistent/https
		cp etc/live/"$host"/privkey.pem tmp/"$host"/etc/persistent/https/server.key
		cp etc/live/"$host"/fullchain.pem tmp/"$host"/etc/persistent/https/server.crt
		cat tmp/"$host"/etc/persistent/https/server.* > tmp/"$host"/etc/server.pem
		scp -r tmp/"$host"/etc "$host":/

		ssh "$host" "cfgmtd -w -p /etc/; killall lighttpd"
	fi
done

echo
echo "Done."
