#!/bin/bash
#dir=home
read -p "请输入目录名: " dir
ls $dir
cd $dir
rm -rf $dir/*
cp /etc/man.config $dir
ls -l $dir
