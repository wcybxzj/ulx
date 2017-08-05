#!/bin/bash
read -p "输入要结束的进程名称: " proc
killall $proc
