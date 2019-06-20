#!/bin/bash
if [[ $# == 0 ]]; then
	echo "must ./1.sh OrderServer "
	exit
fi

name=$1
echo $name
screen -dmS $name /bin/sh -c  "cd /data/docker/zuji && docker-compose exec phpfpm /bin/sh -c \"cd ../OrderServer/ && php artisan command:cronOrderOverdue \""

