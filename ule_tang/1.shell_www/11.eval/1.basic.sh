#!/bin/sh
a="ls|more"

#报错
$a

#正常
eval $a
