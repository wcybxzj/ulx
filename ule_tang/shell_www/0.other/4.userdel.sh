#!/bin/bash
namelist=(jim1 jim2 jim3 jim4 jim5)
for i in ${namelist[@]}
do
	userdel -r $i
	#exit
done
