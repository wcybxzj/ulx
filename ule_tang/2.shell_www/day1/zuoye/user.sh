#!/bin/bash
num=`grep '/bin/bash$' /etc/passwd | wc -l`
if [ $num -gt 5 ]
then
	echo "大于5个"
fi
