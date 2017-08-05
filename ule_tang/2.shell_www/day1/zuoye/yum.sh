#!/bin/bash
mkdir /yum &>/dev/null
umount -f /yum
mount /dev/cdrom /yum
rm -rf /etc/yum.repos.d/*.repo
echo "[centos6.6]" >> /etc/yum.repos.d/yum.repo
echo "name=centos" >> /etc/yum.repos.d/yum.repo
echo "baseurl=file:///yum" >> /etc/yum.repos.d/yum.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/yum.repo
echo "enabled=1" >> /etc/yum.repos.d/yum.repo
yum clean all
yum makecache
if [ $? = 0 ]
then
	echo "yum部署完成,可以正常使用"
fi 
