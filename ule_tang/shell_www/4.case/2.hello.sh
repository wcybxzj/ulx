#!/bin/bash
read -p "plz enter someting" var

case $var in
	nihao | hello)
	echo "你好拆妮子";;
*) 
	echo "你好包外";;
esac
