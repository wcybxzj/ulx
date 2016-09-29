#/bin/bash

#2核cpu以上
#./1.cpu.sh
#top -p pid
#先按f再按j 查看到会运行在不同的cpu上

#taskset -c 0 ./1.cpu.sh
#强制进程固定在0号cpu运行
while true
do
	echo 123
	sleep 1
done

