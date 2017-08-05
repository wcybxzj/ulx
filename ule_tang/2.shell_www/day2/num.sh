#!/bin/bash
num=$(($RANDOM%5+1))
for i in a b c e f
do
read -p "输入您要猜的数值(1~100): " var
	if [ $var -eq $num ]
	then
		echo "you are win"
		break
	elif [ $var -gt $num ]
	then
		echo "you are big"
	else
		echo "you are small"
	fi
done
