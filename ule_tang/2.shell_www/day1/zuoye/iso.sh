#!/bin/bash
iso=`find / -name CentOS6u6.iso`
if [ -z $iso ]
then
	echo "下载centos6u6,挂载使用"
else
	echo "挂载iso镜像到/mnt"
fi
