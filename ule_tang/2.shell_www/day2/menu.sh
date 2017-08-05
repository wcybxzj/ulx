#!/bin/bash	
echo '---------------------------------------------------'
echo '--------------big  fruit  market-------------------'
echo '---apple------banana--------orange-----------------'
echo '---exit--------------------------------------------'
echo '---------------------------------------------------'
while true
do
	read -p "输入你要的水果: " fruit
	if [ $fruit = apple ]
	then
		echo "100/kg"
	elif [ $fruit = banana ]
	then
		echo "200/kg"
	elif [ $fruit = orange ]
	then
		echo "10/kg"
	elif [ $fruit = exit ]
	then
		exit
	else
		echo "本店不卖"
	fi
done
