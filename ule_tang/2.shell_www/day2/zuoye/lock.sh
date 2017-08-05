#!/bin/bash
if [ -f /tmp/lock.lock ]
then
	pid=`cat /tmp/lock.lock`
	if [ -d /proc/$pid ]
	then
		echo "该脚本已运行"
		exit
	fi
fi
echo $$ > /tmp/lock.lock
sleep 1000000
