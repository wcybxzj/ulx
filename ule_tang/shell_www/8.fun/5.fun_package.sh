#!/bin/bash

add(){
	local result=0
	if [ $# -eq 2 ];then
		result=$[$1+$2]
		echo $result
	else
		echo 'need 2 number params'
		return 1
	fi
}

sum(){
	local result=0
	for var in $@
	do
		result=$[$result+$var]
	done
	echo $result
}
