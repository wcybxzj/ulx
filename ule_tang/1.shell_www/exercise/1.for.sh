#!/bin/bash
for name in tom jerry lisi
do
	echo "hi $name"
done

echo "================================="

for name in {tom,jerry,zhangsan,lisi}
do
	echo "hello! $name"
done

echo "================================="

list="tom jerry zhangsan"
for var in list
do
	echo "hello $list"
done




