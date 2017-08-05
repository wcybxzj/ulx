#!/bin/bash
#手动制定
for var in tomtomttom
do
	useradd $var
done


#从变量读出循环列表
var1 = jackjack
for username in $var1
do
	useradd $username
done


#从数组获取
namlist=(tom110 tim10 tom20)
for username in ${var[@]}:
do
	useradd username
done

#从文件获取
for username in `cat work.txt`
	echo $username
