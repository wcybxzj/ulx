#!/bin/bash
while true
do
	free=`df -TH|grep boot | cut -d'M' -f 3|cut -d'.' -f 1`
	if [ $free -le 20 ]
	then
		echo "你的boot分区 可能关键不足 当前空间为 $free'M'" | mail -s 'disk free' root@localhost
		exit
	fi
done
