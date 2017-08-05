#!/bin/bash
i=1

while [ "$i" -le 3 ]; do
	echo "outside loop:":
	for (( j = 1; j <=3 ; j++ )); do
		echo "inssie $j"
	done
	i=$[ $i + 1 ]

	#exit
	#break
	#sleep 100
	continue

done
