#!/bin/bash
for((i=1;i<=10;i++))
do
	echo "test nuber is $i"
done

echo "================="

for (( i = 1,j =10; i <=10; i++,j-- )); do
	echo "test number is $i"
done
