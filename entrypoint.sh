#!/bin/sh

sed -i 's|.*IP-AUTH.*|'newServer\(\{address=\"$DNSDISTCONF_BACKEND_IP\"\,\ tcpOnly=true\,\ pool=\"auth\"\}\)'|g' /etc/dnsdist.conf
sed -i 's|.*IP-REC.*|'newServer\(\{address=\"$DNSDISTCONF_RECURSOR_IP\"\}\)'|g' /etc/dnsdist.conf

if grep -q setKey "/etc/dnsdist.conf"; then
  echo "Key already set, skip."
else
  echo "makeKey()" | dnsdist | grep setKey >> /etc/dnsdist.conf
  echo "controlSocket('0.0.0.0:5199')" >> /etc/dnsdist.conf
fi

echo "Lets Fly our DNSDIST!"

exec "$@"