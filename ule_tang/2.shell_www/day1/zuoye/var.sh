#!/bin/bash
if [ $# -eq 2 ]
then
	echo "ok"
else
	if [ $# -gt 2 ]
	then
		echo "超过2"
	else
		echo "不足2"
	fi
fi
