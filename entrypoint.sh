#!/bin/sh

function RANDOMPW(){
    rando=$( head -100 /dev/urandom | tr -dc a-zA-Z0-9 | fold -w ${1:-15} | head -1 )
    echo $rando
}


sed -i -e 's|SUPERSECRETPWKEY|'$(RANDOMPW)'|g' /etc/dnsdist.conf
sed -i -e 's|SUPERSECRETAPIKEY|'$(RANDOMPW)'|g' /etc/dnsdist.conf

if [ "$DNSDIST_ENABLE_RECURSOR" == "true" ]; then
  sed -i 's|.*IP-AUTH.*|'newServer\(\{address=\"$DNSDISTCONF_BACKEND_IP\"\,\ tcpOnly=true\,\ pool=\"auth\"\}\)'|g' /etc/dnsdist.conf
  sed -i 's|.*IP-REC.*|'newServer\(\{address=\"$DNSDISTCONF_RECURSOR_IP\"\}\)'|g' /etc/dnsdist.conf
  touch /etc/authdomains.txt
  if [ "$DNSDISTCONF_AUTH_MODE" == "API" ]; then
    curl -s -H "X-API-Key: $PDNS_AUTH_APIKEY" http://[$DNSDISTCONF_BACKEND_IP]:80/api/v1/servers/localhost/zones | jq '.[].id' -r | sed 's/.$//' > /etc/authdomains.txt
    unset PDNS_AUTH_APIKEY
  else
    echo $DNSDISTCONF_AUTH_MODE > /etc/authdomains.txt
    if [ -z "$PDNS_AUTH_APIKEY" ]; then unset PDNS_AUTH_APIKEY; fi
  fi
else
  sed -i 's|.*IP-AUTH.*|'newServer\(\{address=\"$DNSDISTCONF_BACKEND_IP\"\,\ tcpOnly=true\}\)'|g' /etc/dnsdist.conf
  sed -i '/.*IP-REC.*/d' /etc/dnsdist.conf  
fi

if grep -q setKey "/etc/dnsdist.conf"; then
  echo "Key already set, skip."
else
  echo "makeKey()" | dnsdist | grep setKey >> /etc/dnsdist.conf
  echo "controlSocket('0.0.0.0:5199')" >> /etc/dnsdist.conf
fi

echo "Lets Fly our DNSDIST!"

exec "$@"