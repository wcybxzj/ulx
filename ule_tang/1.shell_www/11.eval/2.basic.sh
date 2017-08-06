#!/bin/sh

a="123"

#${a}
echo '${'"a"'}'

#再次执行${a}命令
#输出123
eval echo '${'"a"'}'
