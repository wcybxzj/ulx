#/bin/bash
iptables -F
iptables -t filter -A INPUT -p icmp  -m limit --limit 20/minute -j ACCEPT
iptables -t filter -A INPUT -j REJECT
