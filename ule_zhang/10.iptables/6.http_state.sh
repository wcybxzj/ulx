#!/bin/bash
iptables -F
iptables -t nat -F

iptables -P INPUT DROP
iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables  -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
