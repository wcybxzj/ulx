#!/bin/bash
iptables -F
iptables -A INPUT -p tcp --dport 80 -j REJECT --reject-with tcp-reset
