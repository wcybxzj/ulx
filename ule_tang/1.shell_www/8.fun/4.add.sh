#!/bin/bash

abc(){
	#echo $@
	#echo $*
	if [ $# -gt 1 ]; then
		result=$[ $1 + $2 ]
		echo $result
	else
		echo 'not eq'
	fi
	return 222
}
