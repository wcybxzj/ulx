#!/bin/bash

#默认分隔符是空格
#set -- $变量:
#使用分隔符将变量中的值分割存入$1 $2.....$n

#test0:
p="11 22 33 44" ; set -- $p ; echo $4

#test1:
( IFS=/ ; p="/home/vivek/foo/bar" ; set -- $p ; echo $4 )

echo -------------------------------------------------

#test2:
string='one_two_three_four_five'
set -f; IFS='_'
set -- $string
second=$2; fourth=$4
echo $1
echo ========
echo $2
echo ========
echo $3
echo ========
echo $4
echo ========
echo $5
set +f; unset IFS
