#!/bin/bash
for (( i = 0; i <=10; i++ )); do
	if [[ $i == 5 ]]; then
		#break;
		continue;
	fi
	echo "The num is $i"
done
