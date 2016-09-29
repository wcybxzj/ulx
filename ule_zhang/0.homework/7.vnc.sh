#!/bin/bash

for i in {2..254}
do
	{
	ip=172.16.80.$i
	ping -c1 -W1 $ip &>/dev/null
	if [ $? -eq 0 ];then
		nmap $ip|grep vnc &>/dev/null
		if [ $? -eq 0 ];then
		echo "==========="
		echo $ip vnc
		fi
	fi
	}&
done

wait 
echo "finish...."


