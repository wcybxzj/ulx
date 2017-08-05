#!/bin/bash
read -p "plz input yes|YES|y no|NO|n" var

case $var in
yes|YES|y)
	echo 'yyyyy';;
no|NO|n)
	echo 'nnnnnnn';;
*)
	echo "you are wroing"
esac
