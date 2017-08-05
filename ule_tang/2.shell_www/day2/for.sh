#!/bin/bash
for i in `cat /etc/passwd`
do
	sleep 1
	echo $i
done
