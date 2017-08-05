#!/bin/bash
line=`tput lines`
if [ $((line%2)) -eq 1 ]
then
	line=$(((line+1)/2))
else
	line=$((line/2))
fi
col=`tput cols`
#if [ $((col%2)) -eq 1 ]
#then
#	col=$(((col+1)/2))
#else
#	col=$((col/2))
#fi
for ((i=0;i<=$col;i++))
do
usleep 50000
tput cup $(($line-1)) $i
echo -e "\033[31m    ### \033[0m"
tput cup $(($line)) $i
echo -e "\033[31m  ####### \033[0m"
tput cup $(($line+1)) $i
echo -e "\033[3m   O  O \033[0m"
done
