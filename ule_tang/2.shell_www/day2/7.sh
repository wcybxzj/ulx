#!/bin/bash
for i in {1..100}
do
	if [ $(($i%7)) -eq 0 ]
	then
		continue
	elif echo $i | grep 7 &>/dev/null
	then
		continue
	fi
echo $i
done
