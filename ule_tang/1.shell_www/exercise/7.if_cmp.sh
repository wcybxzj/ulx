#!/bin/bash
str1='abcd'
str2='asdsad'
if [ $str1 \< $str2 ]; then
	echo '1 is large'
elif [ $str1 \> $str2 ]; then
	echo '2 is large'
else
	echo 'other'
fi
