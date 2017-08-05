#!/bin/bash
read -p "plz input	yes|YES|y|Y" var
case $var in
	yes | YES | Y |y | Yes)
	echo "hello";;
*)
	echo "you are wrong";;
esac
