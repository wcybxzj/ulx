#!/bin/bash
if date &> /dev/null
then
	echo "command is working"
else
	echo "cmd not found"
fi
