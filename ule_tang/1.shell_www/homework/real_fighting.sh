#!/bin/bash
echo -n 'plz input uname'
read uname
#IFS=$'\n'
for row in `cat /etc/passwd`
do
	#IFS=$'\n'
	print $row
done

