#!/bin/bash
#service httpd start ;chkconfig --level 35  httpd on;
#service mysqld start ;chkconfig --level 35  mysqld on;

#iptables

#create web page
#echo <?php echo 123; > /var/www/html/1.php

if [ -e /usr/bin/elinks ];then
	elinks http://127.0.0.1 &>/dev/null
else
	yum -y install elinks
fi

sleep 5
exit
