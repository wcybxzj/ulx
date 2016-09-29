#!/bin/bash
#本机hosts
#本机/etc/ssh/sshd_config
#本机/etc/yum.repo.d/cent.repo
#目标机ip配置

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
yum install -y expect
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


	#2:
	echo 'scp' $ip '!!!!!!!!!!!!'
	echo "====================================="
	scp /etc/ssh/sshd_config $ip:/etc/ssh/
	scp /etc/hosts $ip:/etc/
	scp /root/www/ule_zhang/0.shell/kvm_deploy/3.ssh.sh $ip:/root
	scp /root/www/ule_zhang/0.shell/kvm_deploy/4.ssh_test.sh $ip:/root
	scp /etc/yum.repos.d/centos.repo $ip:/etc/yum.repos.d/cent.repo
	
	#3
	echo 'hostname and service sshd restart!!!!!!!'
	echo "====================================="
        /usr/bin/expect <<-EOF
	spawn ssh $username@$ip 
	set timeout 20
	expect {
	       "*yes/no" { send "yes\r"; exp_continue }
	       "*password:" { send "$password\r" }
		}

	expect "*]#" { send "hostname $host\r" }
	expect "*]#" { send ">/etc/sysconfig/network\r" }
	expect "*]#" { send "echo NETWORKING=yes >/etc/sysconfig/network\r" }
	expect "*]#" { send "echo HOSTNAME=$host >>/etc/sysconfig/network\r" }
	expect "*]#" { send "service sshd restart\r" }
	expect "*]#" { send "yum install -y tcpdump\r" }
	expect eof
	EOF

	ssh $ip sh /root/3.ssh.sh

	echo "====================================="
	echo "$ip=$host-completed!!!!!!!!!!!!!!!!!!"
	echo "====================================="
	h=$[$h+1]
}&
done
wait
echo "total$count-need-change,$h-completed!!!!!!!!!!!!!!!!!!!!!!!"
echo "done done done !!!"
