#!/bin/bash
iptables -F
iptables -A INPUT -j REJECT
iptables -t filter -I INPUT
