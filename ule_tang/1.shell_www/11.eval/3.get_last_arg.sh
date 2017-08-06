#!/bin/bash
#无论输入几个参数获取最后一个参数
#需要使用eval来实现，因为参数个数是动态的

#[root@web11 11.eval]# ./3.get_last_arg.sh 11 22 33 44 55
#55
eval echo \$$#
