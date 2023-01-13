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
**DNSDIST_ENABLE_RECURSOR** = "false" or "true"  
Auth only or forward recusive?  
**DNSDISTCONF_RECURSOR_IP** = "9.9.9.9"
Your Resolver for non auth zones, if Recursor is enabled.  
**DNSDISTCONF_AUTH_MODE** = "MY.AUTHNS.DOMAIN"  
Required if "RECURSOR" is true.  
Speficy a single Domain if you have one auth domain only.  
Set to "API" if DNSDIST should scrap the auth domains from PDNS-Auth.  
**PDNS_AUTH_APIKEY** = "KEY"  
Required if AUTH_MODE is API. Key is used on Container-Start only and then removed.  
