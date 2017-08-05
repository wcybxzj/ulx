#!/bin/bash
start(){
	if [ -f /tmp/mysql.lock ]
	then
		echo "mysqld is running"
		exit
	else
		 /usr/local/mysql/bin/mysqld_safe --user=mysql 2>&1 >/dev/null & >/dev/null
		touch /tmp/mysql.lock
		echo "mysql start"
	fi
}
stop(){
	if [ -f /tmp/mysql.lock ]
	then
		killall mysqld &>/dev/null
		sleep 1
		while netstat -anplt | grep :3306 &>/dev/null
		do
			killall mysqld
			sleep 1
		done
		rm -rf /tmp/mysql.lock
		echo "mysql stop"
	else
		echo "mysql is not running"
	fi
}
case $1 in 
start)
	start
;;
stop)
	stop
;;
restart)
	stop
	start
;;
*)
	echo "Useage:$0 {start|stop|restart}"
;;
esac
