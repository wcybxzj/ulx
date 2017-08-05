#!/bin/bash
var=1
until [ $var -eq 10 ]
do
	echo "$var"
	var=$[ $var+1 ]
done
echo $var

echo "============================="

declare -i i
declare -i s

until [[ $i = 101 ]]; do
	s=s+i
	i=i+1
done
echo $s
