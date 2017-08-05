#!/bin/bash
service vsftpd status >/dev/null
if [ $? -eq 0 ]
then
	echo "service vsftpd is running"
else
	echo "service vsftpd is stop"
fi
