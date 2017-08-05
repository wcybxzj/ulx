#!/bin/bash

declare -i i
declare -i s

echo $i

while [ "$i" != 101 ]
do
	s=s+i
	i=i+1
done

echo $s
