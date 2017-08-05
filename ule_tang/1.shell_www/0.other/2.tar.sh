#!/bin/bash
tarfile=back-`date +%s`.tgz
#tar -zcf $tarfile $* & > /dev/null
tar -zcf $tarfile $*  > /dev/null 2>&1
echo "$0"
echo "$#"
echo "$*"
