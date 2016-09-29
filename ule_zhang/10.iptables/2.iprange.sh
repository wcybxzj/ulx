#!/bin/bash
iptables -F
iptables -t nat -F
iptables -P INPUT DROP
iptables -P OUTPUT DROP

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -t filter -A INPUT  -p tcp --dport 80 -m iprange --src-range 192.168.91.3-192.168.91.5 -j ACCEPT
iptables -t filter -A OUTPUT  -p tcp --sport 80 -m iprange --dst-range 192.168.91.3-192.168.91.5 -j ACCEPT
