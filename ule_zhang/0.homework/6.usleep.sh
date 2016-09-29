#!/bin/bash
for i in {1..1000000}
do
	usleep 1000000
	echo $i
done
