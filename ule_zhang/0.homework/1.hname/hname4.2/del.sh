#!/bin/bash
echo -n "此操作将会删除vhost.conf文件中的所有虚拟机，包括所有磁盘文件，确定吗？(y/n):"
read a
if [[ "$a" != "y" && "$a" != "yes" ]]
then
	. hname.sh
fi

> /tmp/hname_del
echo -n "删除虚拟机..."
for name in `awk '{print $1}' vhost.conf`
do
	xml_name=`grep -R "<name>$name<\/name>" $xml_dir/* | awk -F: '{print $1}'`
	if [ -z $xml_name ]
	then
		continue
	fi
	cat $xml_name | grep $images_dir | awk -F\' '{print $2}' >> /tmp/hname_del
	virsh destroy $name &>/dev/null
	virsh undefine $name &>/dev/null
done
echo  "完成"

echo -n "清理虚拟机磁盘文件..."
while read d
do
	rm -rf $d &>/dev/null
done < /tmp/hname_del
echo "完成"
rm -rf /tmp/hname_del

