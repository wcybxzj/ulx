#!/bin/bash
echo $$ >/tmp/kkk.pid
select i in ./query.sh ./backup.sh ./rm.sh ./quit.sh
do
	$i
done
