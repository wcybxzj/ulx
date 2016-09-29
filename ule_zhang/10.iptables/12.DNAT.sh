#/bin/bash
iptables -F
iptables  -t nat -F
iptables -t nat -A PREROUTING -i eth2 -d 2.2.2.1 -p tcp --dport 80 -j DNAT --to 192.168.91.3
