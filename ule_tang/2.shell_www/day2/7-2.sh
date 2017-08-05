#!/bin/bash
for i in {1..100}
do
	if [ $(($i%7)) -eq 0  -o $(($i/10)) -eq 7 -o $(($i%10)) -eq 7 ]
then
	continue
	fi
echo $i
done
