#!/bin/bash
rulecount1=`ipvsadm -Ln | grep "10.10.10.*" | wc -l`
if [ $rulecount1 -ne 3 ]
then
        service ipvsadm restart
        rulecount2=`ipvsadm -Ln | grep "10.10.10.*" | wc -l`
        if [ $rulecount2 -ne 3 ]
        then
                service keepalived stop
        fi
fi
