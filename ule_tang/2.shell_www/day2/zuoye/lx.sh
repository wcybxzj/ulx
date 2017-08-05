#!/bin/bash
read -p "输入行数: " line
for ((i=1;i<=line;i++))
do
	for ((k=1;k<=line-i;k++))
	do
		echo -n " "
	done
	for ((j=1;j<=2*i-1;j++))
	do
		echo -n '*'
	done
	echo 
done
for ((i=1;i<line;i++))
do
	for ((k=1;k<=i;k++))
	do
		echo -n " "
	done
	for ((j=1;j<=2*(line-i)-1;j++))
	do
		echo -n '+'
	done
	echo
done
