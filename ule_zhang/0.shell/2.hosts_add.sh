#!/bin/bash
echo "Note:Please write the new hosts into /tmp/hosts !"
read -p "Have you pushed the SSH PubKey for each virtualdomains(y/n):" pk
[ $pk == n ] && read -p "Please input the passwrod of virtualdomains:" pw
read -p "Do you want to clean the existed content of /etc/hosts(y/n):" cpd;
[ $cpd == y ] && sed -ri '3,$d' /etc/hosts;
[ ! -f /usr/bin/expect ] && yum install -y expect &> /dev/null;
[ ! -f /usr/bin/scp ] && yum install -y openssh-clients &> /dev/null;
sed -ri "s/#(.*)ask/\1no/" /etc/ssh/ssh_config;
sed -ri "s/(\tGSSAPIAuthentication )(.*)/\1no/" /etc/ssh/ssh_config;
pubkey() {
/usr/bin/expect << EOF
set timeout 30
log_user 0
spawn ssh-copy-id -i root@${i}
expect "password:"
send "${pw}\r"
expect eof
EOF
}
cd ~/.ssh/;
if [ ! -f id_rsa -o ! -f id_rsa.pub ];then
/usr/bin/expect << EOF
set timeout 30
log_user 0
spawn ssh-keygen
expect "id_rsa):"
send "\r"
expect "passphrase):"
send "\r"
expect "again:"
send "\r"
expect eof
EOF
fi
ssh-add ~/.ssh/id_rsa &> /dev/null;
echo > ~/.ssh/known_hosts;
[ ! -f /tmp/hosts ] && echo "Error:Please touch /tmp/hosts under require!!!" && exit;
lip=`tail -1 /tmp/hosts|awk '{print $1}'`;
for i in `awk '{print $1}' /tmp/hosts`
do
	hn=`grep ${i} /tmp/hosts|awk '{print $2}'`;
	ip a|grep "${i}/" &> /dev/null;
	if [ $? -eq 0 ];then
		if [ $hn != $HOSTNAME ];then
			sed -ri "s/(HOSTNAME=)(.*)/\1${hn}/" /etc/sysconfig/network;
			hostname ${hn};
			echo "${i} ${hn}" >> /etc/hosts;
		fi
		continue;
	fi
	ping -c1 $i &> /dev/null;
	[ $? -ne 0 ] && echo "$i unreachable" && continue;
	[ $pk == n ] && pubkey;
	ssh ${i} "sed -ri 's/(HOSTNAME=)(.*)/\1${hn}/' /etc/sysconfig/network" &> /dev/null && ssh ${i} "hostname ${hn}";
	[ $? -eq 0 ] && echo "Domain ${i} is ok";
	echo "${i} ${hn}" >> /etc/hosts;
	if [ $i == $lip ];then
		echo "Scping /etc/hosts ...";
		for n in `awk '{print $1}' /etc/hosts`
		do
			ip a | grep "$n/" &> /dev/null;
			[ $? -eq 0 ] && continue;
			ping -c1 $n &> /dev/null;
			[ $? -ne 0 ] && echo "$n unreachable,scp failed!" && continue;
			(ssh ${n} "[ ! -f /usr/bin/scp ] && yum install -y openssh-clients" &> /dev/null;
			scp /etc/hosts ${n}:/etc/ &> /dev/null)&
		done
		wait;
		[ $? -eq 0 ] && echo "File /etc/hosts sync ok!"
		echo > /tmp/hosts;
	fi
done
