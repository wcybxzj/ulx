#/bin/bash

for ip in {101..110};
do
	ssh 192.168.122.$ip date
done
