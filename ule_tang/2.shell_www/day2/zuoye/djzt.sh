#!/bin/bash
read -p "输入行数: " line
for ((i=1;i<=line;i++))
do
	for ((k=1;k<=i-1;k++))
	do
		echo -n " "
	done
	for ((j=1;j<=2*(line-i)+1;j++))
	do
		echo -n '+'
	done
	echo
done
