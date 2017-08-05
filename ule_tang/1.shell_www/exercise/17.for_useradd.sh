#!/bin/bash
for i in {1..5}
do
	useradd acc$i
	echo 123456 | passwd acc$i --stdin
done
