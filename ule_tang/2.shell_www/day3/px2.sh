#!/bin/bash
read -p "数值: " var
echo 234 21 4324 53 654 |tr ' ' '\n'|sort -n | tr '\n' ' '
