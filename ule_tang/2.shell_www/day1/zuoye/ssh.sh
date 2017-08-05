#!/bin/bash
if [ $USER = root ]
then
	service sshd restart
else
	echo "you are not root,so switch user to root and start sshd"
fi
