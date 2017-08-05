#!/bin/bash
file=`find / -name man.config`
if [ $file -ef /root/install.log ]
then
	echo "hard link"
else
	echo "no hard link"
fi
