#!/bin/bash	
echo '---------------------------------------------------'
echo '--------------big  fruit  market-------------------'
echo '        1.apple          2.orange     3.banana     '
echo '---     4.exit    ---------------------------------'
echo '---------------------------------------------------'
while true
do
	read -p "输入你要的水果: " fruit
	case $fruit in 
	1)
		echo "apple 100/kg"
	;;
	2)
		echo "orange 200/kg"
	;;
	3)
		echo "banana 400/kg"
	;;
	4)
		exit
	;;
	*)
		echo "本店不卖"
	;;
	esac
done
