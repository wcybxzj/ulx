#!/bin/bash
read -p "输入排序的队列: " var
ary=($var)
count=${#ary[@]}
#echo ${ary[@]} $count
for ((i=0;i<$count;i++))
do
	lower=$i
	for ((j=i+1;j<$count;j++))
	do
		if [ ${ary[$j]} -lt ${ary[$lower]} ]
		then
			lower=$j
		fi
			tmp=${ary[$i]}
			ary[$i]=${ary[$lower]}
			ary[$j]=$tmp
	done
done
echo ${ary[@]}
