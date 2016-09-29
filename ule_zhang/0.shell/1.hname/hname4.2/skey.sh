#!/bin/bash

# 安装相关的软件包
install_expect(){
	echo -n "正在安装expect..."
	yum install expect -y &>/dev/null
	rpm -q expect &>/dev/null
	if [ $? -ne 0 ]
	then 
		echo "安装失败，请检查yum仓库配置。。。"
		exit 1
	fi      
	echo "完成"
}
# END install_expect()


echo "开始上传ssh-key......"

ssh_wait(){
	while true
	do
		ping_filed=0
		for i in `awk '{print $2}' vhost.conf | awk -F, '{print $1}'`
		do
			#echo "i = $i"
			ping -c 1 $i &>/dev/null
			if [ $? -ne 0 ]
			then
				echo "等待$i开机中"
				ping_filed=$(($ping_filed+1))
				sleep 1
			fi
		done
		if [ $ping_filed -eq 0 ]
		then	
			sleep $ssh_stime
			break
		fi
	done
}
# END ssh_wait()

install_expect
ssh_wait
for i in `awk '{print $2}' vhost.conf | awk -F, '{print $1}'`
do
	expect -c " 
	spawn ssh-copy-id $i
	expect { 
		 \"*yes/no*\" { exp_send \"yes\r\"; exp_continue}
		 \"*password:\" {send \"$ssh_pass\r\"}
		}
	interact
	" &> /dev/null
	echo "$i...完成"
	wait
done
