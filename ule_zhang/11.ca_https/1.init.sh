#!/bin/bash
#iptables
#selinux
#ntpdate
#hostname

iptables -F
iptables -t nat -F
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT

setenforce 0

killall ntpd
ntpdate 172.16.8.100
