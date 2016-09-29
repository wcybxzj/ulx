#!/bin/bash
for i in {1..200000}
do
	mysql -uroot -proot -e "insert into testdb.tb1(name) values('stu$i')"
	mysql -uroot -proot -e "select * from testdb.tb1" &> /dev/null
done
