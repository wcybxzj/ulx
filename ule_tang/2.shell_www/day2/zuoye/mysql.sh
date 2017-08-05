#!/bin/bash
mysql_data='/usr/local/mysql/data'
#全备
/usr/local/mysql/bin/mysqldump -u root -p123 --all-databases >> /backup/all.sql &>/dev/null
#备份binlog
/usr/local/mysql/bin/mysqladmin -uroot -p123 flush-logs &>/dev/null
num=`cat /usr/local/mysql/data/master.index | wc -l`
num=$(($num-1))
for i in ` head -$num /usr/local/mysql/data/master.index`
do
	cd $mysql_data
	cp $i /backup
done

