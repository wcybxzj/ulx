#!/bin/bash
A=`ps -C haproxy --no-header | wc -l`
if [ $A -eq 0 ]
	then  /usr/local/haproxy/sbin/haproxy  -f  /usr/local/haproxy/conf/haproxy.cfg
		sleep 3
		if [ `ps -C haproxy --no-header | wc -l `  -eq 0 ]
		then  /etc/init.d/keepalived stop
		fi
fi
