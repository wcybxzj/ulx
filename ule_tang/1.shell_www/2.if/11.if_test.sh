#!/bin/bash

echo -n "plz enter (Y/N) to contiue:"
read Y
if [ $Y == Y ] || [ $Y == y ]; then
	echo "script is running!!!"
else
	echo "script is stopped"
fi
	
