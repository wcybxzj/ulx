#!/bin/bash

#mount -t iso9660  /dev/cdrom  /net
#mount -t iso9660 -o loop /root/rhel.iso /net

repo_path=/etc/yum.repos.d/rhel0322.repo
touch $repo_path
if [ ! -e $repo_path ]; then
	touch $repo_path
fi

echo [rhel0322] > $repo_path
echo name=rhel0322 >> $repo_path
#echo baseurl=file:///mnt >> $repo_path
echo baseurl=ftp://172.16.8.100/rhel6.4>> $repo_path
echo enabled=1 >> $repo_path
echo gpgcheck=0 >> $repo_path

yum clean all
yum makecache
