#!/bin/bash
iptables -F
iptables -t nat -F
iptables -P INPUT DROP
iptables -P OUTPUT DROP

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -t filter -A OUTPUT -p icmp -m icmp --icmp-type echo-request -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT  -p icmp -m icmp --icmp-type echo-reply -m state --state ESTABLISHED -j ACCEPT

