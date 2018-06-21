#!/bin/bash
docker container run \
   -d \
   --rm \
   --name wordpressdb \
   --env MYSQL_ROOT_PASSWORD=123456 \
   --env MYSQL_DATABASE=wordpress \
   mysql:5.7
