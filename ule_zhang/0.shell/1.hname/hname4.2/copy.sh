#!/bin/bash

#获得这台虚拟机的xml配置文件
xml_name=`grep -R "<name>$mname<\/name>" $xml_dir/* | awk -F: '{print $1}'`
#获得这台虚拟机磁盘文件保存路径
#disk_dir=`cat /etc/libvirt/qemu/Qiao-8.xml | grep $images_dir awk -F\' '{print $2}'`
disk_dir=`cat $xml_name | grep $images_dir | awk -F\' '{print $2}'`

for i in `awk '{print $1}' vhost.conf`
do
	qemu-img create -f qcow2 -b $disk_dir $images_dir/$i.qcow2 &>/dev/null
	#echo "xml_name $xml_name"
	cp $xml_name $xml_dir/$i.xml
	sed -i "/<uuid>/d" $xml_dir/$i.xml
	sed -i "/<mac/d" $xml_dir/$i.xml
	sed -i "s#$disk_dir#$images_dir/$i.qcow2#"  $xml_dir/$i.xml
	sed -i "s#<name>$mname#<name>$i#"  $xml_dir/$i.xml
	
	virsh define $xml_dir/$i.xml &>/dev/null
	echo "已安装虚拟机 ${i}......"
done
