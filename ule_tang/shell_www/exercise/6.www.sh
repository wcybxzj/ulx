#!/bin/bash
www=`netstat -an |grep LISTEN|grep :80`
if ["$www" != ""];then
	echo 'www is running!'
else
	echo 'www is not running!'
fi
