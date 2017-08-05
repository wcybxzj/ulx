#!/bin/bash
for ((line=1;line<=4;line++))
do
	for ((col=1;col<=line;col++))
	do
		echo -n '*'
	done
	echo
done
