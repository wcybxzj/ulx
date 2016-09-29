#!/bin/bash
iptables -F
iptables -t nat -F
iptables -P INPUT DROP
iptables -P OUTPUT DROP

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -t filter -A OUTPUT -p icmp -m icmp --icmp echo-request -j ACCEPT
iptables -t filter -A INPUT  -p icmp -m icmp --icmp echo-reply -j ACCEPT

