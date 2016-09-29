#/bin/bash
iptables -P INPUT  ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
#only allow 2 ssh connect in a client
iptables -A INPUT -p tcp --syn --dport 22 -m connlimit  --connlimit-above 2 -j REJECT
