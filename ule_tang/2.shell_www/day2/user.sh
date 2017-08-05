#!/bin/bash
for i in {1..50}
do
	useradd abc$i 
	echo '123' | passwd --stdin abc$i 
done
