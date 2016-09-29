#!/bin/bash

#第一种定义方法:
function fun1 {
	#for var in {tom44,tom45}
	#do

	#done

	for var in {tom001,tom002,tom003}
	do
		useradd $var
		echo  123| passwd --stdin $var
	done


	#for var in {tom001,tom002,tom003}
	#do
	#	userdel -r $var
	#done


	#for var in `cat /etc/passwd`
	#do
	#	echo $var
	#done

}
#第二种定义方式
fun2() {
	echo 2222
}

#fun1
fun2
