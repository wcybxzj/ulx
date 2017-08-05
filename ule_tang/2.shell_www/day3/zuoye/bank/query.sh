#!/bin/bash
clear 
echo "----------------"
echo "---1.查询-------"
echo "---2.返回-------"
echo "----------------"
while true
do
read -p "输入操作: " var
case $var in 
1)
	money=`mysql -u root -p123 -e "select money from bank.bank where name='$account' \G" 2> /dev/null | tail -1 | cut -d' ' -f 2`
	echo "您帐号的余额为:${money}元"
;;
2)
	. ./menu.sh
;;
esac
done
