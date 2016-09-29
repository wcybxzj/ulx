#!/bin/bash
while true
do
	SELECT=`mysql -uroot -proot --batch -e "SHOW GLOBAL STATUS LIKE 'com_select'" | awk '/Com/{print $2}'`
	rrdtool update mysql.rrd N:$SELECT
	sleep 3
done
