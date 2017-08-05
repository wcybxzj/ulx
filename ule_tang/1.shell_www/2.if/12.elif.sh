#!/bin/bash

read -p "plz enter:" word

if [ "$1" == hello ];then
	echo "hello"
elif [ "$1" == "" ];then
	echo 'empty'
else
	echo 'not empty'
fi

echo -----------------------------------------------


if [ "$word" == hello ];then
	echo "hello"
elif [ "$word" == "" ];then
	echo 'empty'
else
	echo 'not empty'
fi
