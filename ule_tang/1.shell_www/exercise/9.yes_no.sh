#!/bin/bash
echo -n "plz input:"
read var

case $var in
	yes | y | Y)
	echo "yes";;
	no | n | N)
	echo "nononoo";;
esac

