#!/bin/bash
read -p "输入变量 " var
if [ -z $var ]
then
	echo "空值"
else
	echo "正确"
fi
