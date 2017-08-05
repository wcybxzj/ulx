#!/bin/bash
if [[ "$1" = "hello" ]]; then
	echo "Hello! How are you?" 
elif [[ $1 = "" ]]; then
	echo "hello! how are u!"
else
	echo "other"
fi
