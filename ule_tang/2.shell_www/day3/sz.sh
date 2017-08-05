#!/bin/bash
num=`wc -l /etc/passwd | cut -d' ' -f 1`
for ((i=1;i<=$num;i++))
do
	ary[$i]=`head -$i /etc/passwd | tail -1`
	echo ${ary[$i]}
	echo
done
