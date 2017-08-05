#!/bin/bash
clear
tput sc
for i in {1..10}
do
	tput cup 10 39
	echo -e "\033[32m $i \033[0m"
	sleep 1
done
tput cup 10 39
echo -e "\033[41;32m baozhao \033[0m"
tput rc
