#!/bin/bash
read -p "输入帐号: " account
read -p "输入密码: " password
user=`head -1 ./user.txt`
pass=`tail -1 ./user.txt`

if [ $account = $user  -a  $password -eq $pass ]
then
	echo "登录成功"
else
	echo "登录失败"
fi
