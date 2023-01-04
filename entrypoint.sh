#!/bin/sh

sed -i 's|.*newServer.*|'newServer\(\{address=\"fdaa:1:160b:0:1::2\"\,\ tcpOnly=true\}\)'|g' /etc/dnsdist.conf

if grep -q setKey "/etc/dnsdist.conf"; then
  echo "Key already set, skip."
else
  echo "makeKey()" | dnsdist | grep setKey >> /etc/dnsdist.conf
  echo "controlSocket('0.0.0.0:5199')" >> /etc/dnsdist.conf
fi

echo "Lets Fly our DNSDIST!"

exec "$@"