#/bin/bash
#server: nc 127.0.0.1 -l -u 9999
#client: nc 127.0.0.1 -u 9999 
iptables -F
for i in NEW ESTABLISHED RELATED INVALID
do
	iptables -A OUTPUT -p udp --dport 9999 -m state --state $i -j LOG --log-prefix " OUT_9999_$i "
	iptables -A INPUT  -p udp --sport 9999 -m state --state $i -j LOG --log-prefix " IN_9999_$i "
done
