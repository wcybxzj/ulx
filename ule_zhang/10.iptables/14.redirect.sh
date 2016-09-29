#!/bin/bash
iptables -F
iptables -t nat -F

iptables -t nat -A PREROUTING -p tcp --dport 8080 -j REDIRECT --to-port 80
#本地lo不走prerouting 所以本地访问必须设置在output
iptables -t nat -A OUTPUT -p tcp --dport 8080 -j REDIRECT --to-port 80
