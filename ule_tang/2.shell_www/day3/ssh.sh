#!/bin/bash
for i in {1..253}
do
	( if ping -c 1 172.16.80.$i &>/dev/null
	then
		echo 172.16.80.$i >> /tmp/ip.txt
	fi ) &
done
wait
for i in `cat /tmp/ip.txt`
do
	pass=uplooking
	/usr/bin/expect <<EOF
	set timeout 30
	spawn ssh $i useradd auteman
	expect "(yes/no)?"
	send "yes\r"
	expect "password:"
	send "$pass\r"
	expect eof
EOF
done
