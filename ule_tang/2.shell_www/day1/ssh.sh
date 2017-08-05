#!/bin/bash
if [ -f /etc/ssh/sshd_config ]
then
	service sshd restart
else
	echo "install your sshd service"
fi
