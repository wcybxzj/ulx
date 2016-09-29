#!/bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -F
iptables -t nat -F
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -t filter -A FORWARD -p tcp -m iprange --src-range 192.168.91.1-192.168.91.3 -j DROP
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to 2.2.2.2
