#!/bin/bash

IFS=$":"
for var in `cat /etc/passwd`
do
	echo "hello $var"
done
