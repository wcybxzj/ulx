#!/bin/bash
# 2016-07-12 by dhd
# 1. Create ssh-keygen
# 2. scp authorized_keys and hosts
# 3. Change hostname
# Note
# 1. SSH not need to inter yes
# 2. Create ssh-keygen for the first time
#############################################################

pass=uplooking
ip=`ifconfig eth0 | sed -n '2p'| cut -d: -f2 | cut -d" " -f1`
lname=`cat /etc/hosts | grep ^$ip | awk '{print $2}'`

# hosts
#for i in 10 20 30 40 50; do echo -e "192.168.122.$i\tnode$i.example.com" >> /etc/hosts; done

# change local hostname
#sed -i "s/^HOS.*/HOSTNAME=$lname/" /etc/sysconfig/network; hostname $lname

yum repolist &> /dev/null
[ $? != 0 ] echo "Check yum" && exit 1 || yum -y install expect

## ssh-keygen
#/usr/bin/expect <<END
#spawn ssh-keygen -b 1024 -t rsa
#expect "*id_rsa*"
#send "\r"
#expect "*passphrase):"
#send "\r"
#expect "*again:"
#send "\r"
#expect eof
#END

# ssh-copy-id
for dip in `cat /etc/hosts |grep -v $ip | awk 'NR>2 {print $1}'|grep -v ^#`
do
#dip=192.168.122.10
expect -c "
set timeout -1
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $dip
expect \"*password:\"
send \"$pass\r\"
expect eof" 

scp /etc/hosts $dip:/etc

name=`grep ^$dip /etc/hosts | awk '{print $2}'`
ssh $dip "sed -i "s/^HOS.*/HOSTNAME=$name/" /etc/sysconfig/network"
ssh $dip "hostname $name"
done

