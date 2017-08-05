#!/bin/bash
for i in {1..50}
do
	for j in {1..50}
	do
		if [ $j -eq 10 ]
		then 
			exit
		fi
	echo "$i::$j"
	done
done
