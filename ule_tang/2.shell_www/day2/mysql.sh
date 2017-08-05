#!/bin/bash
service mysqld start &>/dev/null
var=$?
if [ $var -eq 0 ]
then
	#echo "`date` mysqld is ok" >> /tmp/mysql.log
	#logger "`date` mysqld is ok"
	logger -p local6.info -f /var/log/test.log "`date` mysql is ok"
elif [ $var -eq 1 ]
then
	#echo "`date` mysql can not runing" >> /tmp/mysql.err
	#logger "`date` mysqld can not running"
	logger -p local6.info -f /var/log/test.log "`date` mysql can not running"
fi
