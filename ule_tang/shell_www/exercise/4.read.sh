#!/bin/bash
echo -n "plz y to continue:"
read yn
if [[ $yn = "y" ]]; then
	echo "running"
else
	echo "stoped"
fi
