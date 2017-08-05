#!/bin/bash
read -p "输入你要删除文件的名字: " name
rm -rf /backup/$name
