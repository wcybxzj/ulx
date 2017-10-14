#!/bin/sh

fun1(){
	cat > /tmp/123.txt
}

fun(){
	echo $@
	fun1
}

fun 123 <<EOF
456
EOF
