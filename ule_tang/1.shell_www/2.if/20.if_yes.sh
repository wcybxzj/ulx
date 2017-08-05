#!/bin/bash
read -p "plz input	yes|YES|y|Y" var
if [ "$var" = yes ];then
	echo 1
elif [ "$var" = YES ];then
	echo 2
elif [ "$var" = Y ];then
	echo 3
elif [ "$var" = y ];then
	echo 4
else
	echo "wrong"
fi
