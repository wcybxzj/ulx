#!/bin/bash
if [ -f /tmp/kk.txt ]
then
	if [ -r /tmp/kk.txt ]
	then
		ls -l /tmp/kk.txt
	else
		chmod a+r /tmp/kk.txt
	fi
else
	touch /tmp/kk.txt
	if [ -x /tmp/kk.txt ]
	then
		ls -l /tmp/kk.txt
	else
		chmod a+x /tmp/kk.txt
	fi
fi
