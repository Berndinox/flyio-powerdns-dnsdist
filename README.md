# flyio-powerdns-dnsdist
DNS LB and SEC for Fly.io  
Is connecting a PDNS Instance on Fly.io.    
From the PDNS App issue: `flyctl ips allocate-v6 --private`  

## Note
The PDNS Backend has to be connected via TCP because of the internal routing possibilities of fly.io.  
UDP is not working at time of writing.  
The config will automaticly add  `tcpOnly=true` to the backend servers.  

## Config
**DNSDISTCONF_BACKEND_IP** = "[::0]"  
The private IPv6 IP of the PDNS Auth Server (see outpul above cmd).  