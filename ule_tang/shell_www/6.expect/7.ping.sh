#!/bin/bash


##第一部分生成公钥密钥
#/usr/bin/expect << EOF
#spawn ssh-keygen
#expect {
#		"(/root/.ssh/id_rsa):" {send "\r";exp_continue}
#		"(empty for no passphrase):" {send "\r";exp_continue}
#		"again:" {send "\r";exp_continue}
#}
#EOF

##第二部分ping 生成ip列表
#network=172.16.80
#for i in {1..254}
#do
#	ping -c 1 $network.$i |grep '100%' &>/dev/null
#	if [ $? -eq 1 ];then
#		echo $network.$i
#		echo $network.$i >> ip.txt
#		echo 'ok'
#	else
#		echo 'fail'
#	fi
#done

#第三部分:ssh-copy-id
while read ip
do

/usr/bin/expect << EOF
set passwd "uploooing"
set timeout 3
spawn ssh-copy-id root@$ip
expect {
	"yes/no)?" {send "yes\r";exp_continue}
	"password:" {send "uplooking\n"; exp_continue}
}
EOF
scp 7.ping.sh root@$ip:/tmp/ybx.sh
done < ip.txt
