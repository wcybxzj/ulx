#!/bin/bash

www=`netstat -anptu | grep LISTEN | grep :80`
if [ "$www" != "" ];then
	echo "www is working"
else
	echo "www is stopped"
fi

ftp=`netstat -anptu | grep LISTEN | grep :21`
if [ "$ftp" != "" ];then
	echo "ftp is working"
else
	echo "ftp is stopped"
fi

ssh=`netstat -anptu | grep LISTEN | grep :22`
if [ "$ssh" != "" ];then
	echo "ssh is working"
else
	echo "ssh is stopped"
fi

smtp=`netstat -anptu | grep LISTEN | grep :25`
pop3=`netstat -anptu | grep LISTEN | grep :110`
if [ "$smtp" != "" ] || [ "$pop3" != "" ];then
	echo "smtp and pop3 are fine"
elif [ "$smtp" = "" ];then
	echo "smtp fail"
elif [ "$pop3" = "" ];then
	echo "pop3 fail"
else
	echo "both failed"
fi
