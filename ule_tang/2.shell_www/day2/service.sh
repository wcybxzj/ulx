#!/bin/bash
. /etc/init.d/functions
start(){
	if [ -f /tmp/nc.lock ]
	then
		echo_failure
		echo "service is running"
		exit
	else
		nc -l 9999 &
		touch /tmp/nc.lock
		echo_success
		echo "start"
	fi
}
stop(){
	if [ -f /tmp/nc.lock ]
	then
		pid=`pidof nc`
		kill -9 $pid
		rm -rf /tmp/nc.lock
		echo_success
		echo "stop"
	else
		echo_failure
		echo "service in not runging"
	fi
}
case $1 in 
start)
	start
;;
stop)
	stop
;;
restart|reload)
	stop
	start
;;
*)
	echo "Useage $0: {start|stop|restart|reload}"
;;
esac
