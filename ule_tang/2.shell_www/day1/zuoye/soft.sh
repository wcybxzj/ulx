#!/bin/bash
if rpm -q nmap &>/dev/null
then
	echo "已安装"
else
	echo "未安装"
	yum install nmap
fi
