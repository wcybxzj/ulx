#!/bin/bash
network=192.168.91
for i in {1..254}
do
	#下面括号相当于fork
	{
		ping -c 1 $network.$i |grep '100%' &>/dev/null
		if [ $? -eq 1 ];then
			echo $network.$i
		fi
	}&
done

for i in {1.. 254}
do
	wait
done
