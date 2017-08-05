#!/bin/bash
echo -n 'plz input number of month:'
read number
case $number in
1)
echo "the month is Jan";;
2)
echo "the month is Feb";;
*)
echo "3-12";;
esac
