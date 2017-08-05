#!/bin/bash
#输入:80
read -p "plz enter port" port
www=`netstat -anput | grep LISTEN | grep $port`
if [ "$www" != "" ];then
	echo "have"
else
	echo "not"
fi
