#!/bin/bash
for i in + - \* /
do
	for j in + - \* /
	do
		for x in + - \* /
		do
			for y in + - \* /
			do
				var=$((1${i}2${j}3${x}4${y}5))
				if [ $var -eq 23 ]
				then
					echo 1${i}2${j}3${x}4${y}5=23
				fi
			done
		done
	done
done
