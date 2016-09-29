#!/bin/bash

yum install -y expect

if [ ! -f ~/.ssh/id_rsa.pub ];then
        echo "ssh-keygen建立密钥！！！"
	/usr/bin/expect <<-EOF
	spawn ssh-keygen -b 1024 -t rsa
	expect "*id_rsa*"
	send "\r"
	expect "*passphrase):"
	send "\r"
	expect "*again:"
	send "\r"
	expect eof
	EOF
fi
sed -i '/^$/d' /etc/hosts >/dev/null
username=root
password=uplooking

count=`cat /etc/hosts|wc -l`

for ((i=3;i<=$count;i++))
do
{
	ip=`sed -n "$i"p /etc/hosts|awk -F" " '{print $1}'`
	host=`sed -n "$i"p /etc/hosts|awk -F" " '{print $2}'`
	ping -c 1 $ip >/dev/null
	if [ $? -ne 0 ]
		then
		echo "$ip $host-network-unreasonable"
		continue
	fi

	#1:ssh-copy-id
	echo 'ssh-copy-id' $ip '!!!!!!!!!!!!!!!'
	echo "====================================="
        /usr/bin/expect <<-EOF
	set timeout 25
	spawn ssh-copy-id -i $ip
	expect {
		"*yes/no" { send "yes\r"; exp_continue}
		"*password:" { send "uplooking\r" }
	}
	expect "#"
	send "exit\r"
	expect eof
	EOF

        /usr/bin/expect <<-EOF
	set timeout 25
	spawn ssh-copy-id -i $host
	expect {
		"*yes/no" { send "yes\r"; exp_continue}
		"*password:" { send "uplooking\r" }
	}
	expect "#"
	send "exit\r"
	expect eof
	EOF

}&
done
wait
echo "ssh total$count-need-change,$h-completed!!!!!!!!!!!!!!!!!!!!!!!"
echo "done done done !!!"
