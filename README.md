# flyio-powerdns-dnsdist
DNS LB and SEC for Fly.io  
Is connecting a PDNS Instance on Fly.io.    
From the PDNS App issue: `flyctl ips allocate-v6 --private`  

## Config
DNSDISTCONF_BACKEND_IP = "[::0]"  
The private IPv6 IP of the PDNS Auth Server (see outpul above cmd).  