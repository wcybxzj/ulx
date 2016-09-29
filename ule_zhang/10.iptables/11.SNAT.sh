#/bin/bash
iptables -F
iptables  -t nat -F

#eth2 2.2.2.2
#iptables -t nat -A POSTROUTING -s 192.168.91.0/24 -o eth2 -j SNAT --to-source 2.2.2.1
iptables -t nat -A POSTROUTING -s 192.168.91.0/24 -o eth2 -j MASQUERADE
