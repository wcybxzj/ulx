#!/bin/bash
var=1

while [ $var -lt 10 ]
do
	echo $var
	var=$[ $var+1 ]
done
