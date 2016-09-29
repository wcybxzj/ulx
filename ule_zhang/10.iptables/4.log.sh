#!/bin/bash
iptables -F
iptables -t nat -F
iptables -A INPUT   -p icmp -m icmp --icmp-type echo-reply -m state --state NEW -j LOG --log-prefix " IN_ICMP_NEW " 
iptables -A INPUT   -p icmp -m icmp --icmp-type echo-reply -m state --state ESTABLISHED -j LOG --log-prefix " IN_ICMP_ES " 
iptables -A INPUT   -p icmp -m icmp --icmp-type echo-reply -m state --state RELATED -j LOG --log-prefix " IN_ICMP_RE " 
iptables -A INPUT   -p icmp -m icmp --icmp-type echo-reply -m state --state INVALID -j LOG --log-prefix " IN_ICMP_IN " 

iptables -A OUTPUT  -p icmp -m icmp --icmp-type echo-request -m state --state NEW -j LOG --log-prefix " OUT_ICMP_NEW " 
iptables -A OUTPUT  -p icmp -m icmp --icmp-type echo-request -m state --state ESTABLISHED -j LOG --log-prefix " OUT_ICMP_ES " 
iptables -A OUTPUT  -p icmp -m icmp --icmp-type echo-request -m state --state RELATED -j LOG --log-prefix " OUT_ICMP_RE " 
iptables -A OUTPUT  -p icmp -m icmp --icmp-type echo-request -m state --state INVALID -j LOG --log-prefix " OUT_ICMP_IN " 
