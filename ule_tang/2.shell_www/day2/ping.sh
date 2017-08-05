#!/bin/bash
for i in {1..254}
do
	( if ping -c 1 172.16.80.$i  &>/dev/null
	then
		echo 172.16.80.$i is link
	else
		echo 172.16.80.$i is not link
	fi ) &
done
