#!/bin/bash
while true
do
	rrdtool update test.rrd N:$RANDOM
	sleep 5
done
