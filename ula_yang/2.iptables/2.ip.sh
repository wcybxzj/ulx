#!/bin/bash
iptables -F
iptables -A INPUT -j REJECT
#iptables -t filter -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -I INPUT -i lo -j ACCEPT
iptables -L
