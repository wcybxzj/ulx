#!/bin/bash
use=`free -m | grep Mem | cut -d' ' -f 18`
free=`free -m | grep Mem | cut -d' ' -f 25`
if [ $use -gt $free ]
then
	echo "memory使用率超过50%"
else
	echo "状态正常"
fi
