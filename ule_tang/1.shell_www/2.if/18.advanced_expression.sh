#!/bin/bash


read -p "plz enter your number:" var1

if (( $var1 ** 2 > 1 ))
then
(( var2=$var1 ** 2 ))
echo "the square pf $var1 is $var2"
fi
