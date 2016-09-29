#!/bin/bash
#用audit查pid ppid
#lsof -p pid 查到文件
while :;
do
	touch /tmp/123.txt
	sleep 1;
done

