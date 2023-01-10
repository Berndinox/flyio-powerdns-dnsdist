# flyio-powerdns-dnsdist
**DNS LB and SEC for Fly.io PowerDNS**

Credits and thanks to:
 - https://dnsdist.org/  
 - https://github.com/chrisss404/powerdns  


Is connecting https://github.com/Berndinox/flyio-powerdns-pg on fly.io.    
The above linked PDNS Instance needs an private IPv6 for receiving traffic from DNSDIST: `flyctl ips allocate-v6 --private -a MY-PDNS-APP`  

## Attention
Alpha stage - no warranty for any bugs or security issues.

## Note
The PDNS Backend has to be connected via TCP because of the internal routing possibilities of fly.io.  
UDP is not working at time of writing.  
The config will automaticly add  `tcpOnly=true` to the PDNS-Auth Backend.  

## Config
**DNSDISTCONF_BACKEND_IP** = "[::0]"  
The private IPv6 IP of the PDNS Auth Server (see outpul above cmd).  
**DNSDISTCONF_RECURSOR_IP** = "9.9.9.9"
Your Resolver for non auth zones.  
**DNSDISTCONF_MAIN_DOMAIN** = "MY.AUTHNS.DOMAIN"
Specify the Domain of your Nameserver itself here.
