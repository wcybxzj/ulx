#!/bin/bash
var=1
until [ $var -eq 10 ]
do
echo $var
var=$[ $var + 1 ]
done

echo $var
