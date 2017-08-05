#!/bin/bash
namelist=(jim1 jim2 jim3 jim4 jim5)
for i in ${namelist[@]}
do
	useradd $i &>/dev/null
	echo 123|passwd --stdin $i &>/dev/null
	grep "^$i" /etc/passwd | cut -d : -f 1,3
	#exit
done
