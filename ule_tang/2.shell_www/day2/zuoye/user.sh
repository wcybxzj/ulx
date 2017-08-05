#!/bin/bash
for i in {1..50}
do
	if id abc$i &> /dev/null
	then
		echo "the user abc$i is in system"
	else
		useradd abc$i &
		wait
		echo 123 | passwd --stdin abc$i &
	fi	
done
