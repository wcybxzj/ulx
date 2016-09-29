#!/bin/bash
# hname v4.2
# by: QiaoWence  2016-7 ce9792944@gmail.com

clear

#载入配置文件
for i in `awk '$0!~/^$/&&$0!~/^#/{print $1":"$2}' hname.conf`
do
	name=`echo $i | awk -F: '{print $1}'`
	value=`echo $i | awk -F: '{print $2}'`
	eval "${name}=${value}"
done

echo "-------------------------------"
echo " hname v4.2 "
echo
echo "      1.拷贝虚拟机 "
echo "      2.修改虚拟机环境"
echo "      3.上传ssh公钥"
echo "      4.配置hosts解析"
echo "      0.一键部署(同时执行以上4项)"
echo "      d.删除列表文件中的虚拟机"
echo "      q.退出"
echo
echo "-------------------------------"
while true
do
	echo -n "请选择(输入m显示菜单):"
	read -p "" c
	case $c in
	1)
		. copy.sh
	;;
	2)
		. edit.sh
	;;
	3)
		. skey.sh
	;;
	4)
		. host.sh
	;;
	0)
		. copy.sh
		. edit.sh
		. skey.sh
		. host.sh
	;;
	q)
		exit 0
	;;
	d)
		. del.sh
	;;
	m)
		. hname.sh
	;;
	*)
		echo "输入错误！"
	;;
	esac
done
