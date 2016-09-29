#!/bin/bash
iptables -F
iptables -A INPUT -j REJECT							
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp --dport 20:21 -j ACCEPT
iptables -I INPUT -p tcp --dport 22 -j ACCEPT


iptables -I INPUT -i lo -j ACCEPT
#iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -nL
