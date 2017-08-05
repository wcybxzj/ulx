#!/bin/bash
until `w | grep ^robin &> /dev/null`  
do
	:
done
echo robin `date` > /tmp/user.txt
