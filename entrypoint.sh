#!/bin/sh

function RANDOMPW(){
    rando=$( head -100 /dev/urandom | tr -dc a-zA-Z0-9 | fold -w ${1:-15} | head -1 )
    echo $rando
}

sed -i 's|.*IP-AUTH.*|'newServer\(\{address=\"$DNSDISTCONF_BACKEND_IP\"\,\ tcpOnly=true\,\ pool=\"auth\"\}\)'|g' /etc/dnsdist.conf
sed -i 's|.*IP-REC.*|'newServer\(\{address=\"$DNSDISTCONF_RECURSOR_IP\"\}\)'|g' /etc/dnsdist.conf
sed -i -e 's|SUPERSECRETPWKEY|'$(RANDOMPW)'|g' /etc/dnsdist.conf
sed -i -e 's|SUPERSECRETAPIKEY|'$(RANDOMPW)'|g' /etc/dnsdist.conf

if [ "$DNSDISTCONF_MAIN_DOMAIN" == "dnskrake.top" ]; then
  echo "66.241.125.160   dash.dnskrake.top"  >> /etc/hosts
  curl -s https://dash.dnskrake.top/static/domainlist.txt --output /etc/authdomains.txt
fi

if [ ! -s /etc/authdomains.txt ]; then
  echo $DNSDISTCONF_MAIN_DOMAIN > /etc/authdomains.txt
fi

if grep -q setKey "/etc/dnsdist.conf"; then
  echo "Key already set, skip."
else
  echo "makeKey()" | dnsdist | grep setKey >> /etc/dnsdist.conf
  echo "controlSocket('0.0.0.0:5199')" >> /etc/dnsdist.conf
fi

echo "Lets Fly our DNSDIST!"

exec "$@"