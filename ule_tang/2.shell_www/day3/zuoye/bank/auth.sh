#!/bin/bash
read -p "输入帐号: " account
name=`mysql -u root -p123 -e "select name from bank.bank where name='$account'\G" 2> /dev/null | tail -1 | cut -d' ' -f 2`
if [ ! -z $name ]
then
	read -p "输入密码: " passwd
	password=`mysql -u root -p123 -e "select password from bank.bank where name='$account'\G" 2> /dev/null | tail -1 | cut -d' ' -f 2`
	if [ $passwd -eq $password ]
	then
		echo "登录成功"
		. ./menu.sh
	else
		echo "登录失败"
	fi
else
	
	read -p "输入密码: " passwd
	echo "登录失败"
fi
