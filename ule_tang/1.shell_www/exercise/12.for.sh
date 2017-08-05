#!/bin/bash

#for name in {tom,jerry,zhangsan}
for name in tom jerry zhangsan
do
	echo "hello $name"
done

echo "------------------"

list="111 222 3333"
for var in $list
do
	echo "hello world"
done
	
