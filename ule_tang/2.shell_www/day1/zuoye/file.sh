#!/bin/bash
if [ -f /tmp/aa.txt ]
then
	echo "文件存在,稍后...."
	sleep 1 	
	ls -l /tmp/aa.txt
else
	echo "文件不存在,创建..."
	sleep 1
	touch /tmp/aa.txt
fi
