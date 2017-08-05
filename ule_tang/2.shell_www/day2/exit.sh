#!/bin/bash
for i in {1..5}
do
	echo $i
	if [ $i -eq 3 ]
	then
		exit 100
	fi
done
