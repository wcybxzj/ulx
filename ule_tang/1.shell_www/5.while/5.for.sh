#!/bin/bash



for (( i = 1; i <=3; i++ ))
do
	for (( j = 1; j <=3; j++ ))
	do
		echo "inside loop $j"
	done
	echo "outside loop:$i"
done

