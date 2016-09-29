#!/bin/bash
#批量修改虚拟机的ip地址，主机名，相互解析
#必须要在虚拟机关机状态下使用!!
#by: QiaoWence  2016-7

images_dir=/var/lib/libvirt/images
xml_dir=/etc/libvirt/qemu

#fix_eth $name $ip $n
#fix_eth 虚拟机名 ip地址 eth(n)
fix_eth(){
	#写入网卡IP地址
	cp -rf /tmp/hname/mode/ifcfg-eth0 /tmp/hname/$name/ifcfg-eth$3
	sed -i "s/eth0/eth$3/g" /tmp/hname/$1/ifcfg-eth$3
	sed -i /BOOTPROTO=/d /tmp/hname/$1/ifcfg-eth$3
	echo 'BOOTPROTO="static"' >> /tmp/hname/$1/ifcfg-eth$3
	sed -i /IPADDR=/d /tmp/hname/$1/ifcfg-eth$3 
	echo "IPADDR=$2" >> /tmp/hname/$1/ifcfg-eth$3 
	sed -i /PREFIX=/d /tmp/hname/$1/ifcfg-eth$3 
	echo "PREFIX=24" >> /tmp/hname/$1/ifcfg-eth$3
	sed -i /GATEWAY=/d /tmp/hname/$1/ifcfg-eth$3 
	#如果为192.168.122.0网段，就写入一个网关
	if [[ $2 = 192\.168\.122\.* ]]
	then
		echo "GATEWAY=192.168.122.1" >> /tmp/hname/$1/ifcfg-eth$3
	fi
	virt-copy-in -a $disk_dir /tmp/hname/$1/ifcfg-eth$3 /etc/sysconfig/network-scripts
}

#fix_hosts $name $ip $pc_name
#fix_hosts 虚拟机名 ip地址 主机名
fix_hosts(){
	echo "$2  $3" >> /tmp/hname/$1/hosts
}


echo -n "正在安装相关软件包..."
yum install libguestfs-tools -y &>/dev/null 
rpm -q libguestfs-tools &>/dev/null
if [ $? -ne 0 ]
then
	echo "安装失败，请检查yum仓库配置。。。"
	exit 1
fi
echo "完成"

mname=`head -1 mode.conf`
echo -n "正在获取$mname的配置文件..."
#把模板虚拟机的名字保存到$mname里

#获得这台虚拟机的xml配置文件
xml_name=`grep -R "<name>$mname<\/name>" $xml_dir/* | awk -F: '{print $1}'`
#获得这台虚拟机磁盘文件保存路径
#disk_dir=`cat /etc/libvirt/qemu/Qiao-8.xml | grep $images_dir awk -F\' '{print $2}'`
disk_dir=`cat $xml_name | grep $images_dir | awk -F\' '{print $2}'`

#virt-copy-out -a /var/lib/libvirt/images/Qiao-9.qcow2 /etc/sysconfig/network /tmp
mkdir /tmp/hname/mode -p
virt-copy-out -a $disk_dir /etc/sysconfig/network /tmp/hname/mode
virt-copy-out -a $disk_dir /etc/hosts /tmp/hname/mode
virt-copy-out -a $disk_dir /etc/sysconfig/network-scripts/ifcfg-eth0 /tmp/hname/mode
echo "完成"

#主循环，循环次数为虚拟机的个数
for name in `cat hname.conf | awk '{print $1}'`
do
	#获得这台虚拟机的xml配置文件
	xml_name=`grep -R "<name>$name<\/name>" $xml_dir/* | awk -F: '{print $1}'`
	#获得这台虚拟机磁盘文件保存路径
	#disk_dir=`cat /etc/libvirt/qemu/Qiao-8.xml | grep $images_dir awk -F\' '{print $2}'`
	disk_dir=`cat $xml_name | grep $images_dir | awk -F\' '{print $2}'`
	echo -n "正在修改$name..."

	mkdir /tmp/hname/$name -p
	#拷贝配置文件

	#拷贝模板虚拟机的配置文件
	cp -rf /tmp/hname/mode/hosts /tmp/hname/$name
	cp -rf /tmp/hname/mode/network /tmp/hname/$name

	#从配置文件中获得当前虚拟机的IP地址和主机名
#	ip=`awk -v n=$name '$1~n{print $2}' hname.conf`
	host_name=`awk -v n=$name '$1~n{print $3}' hname.conf`
	#写入主机名
	sed -i /HOSTNAME=/d /tmp/hname/$name/network
	echo "HOSTNAME=$host_name" >> /tmp/hname/$name/network
	#写入hosts解析文件
	for pc_name in `cat hname.conf | awk '{print $3}'`
	do
		for h_ip in `awk -v a=$pc_name 'a~$3{print $2}' hname.conf | sed 's/,/ /g'`
		do
			fix_hosts $name  $h_ip $pc_name
		done
	done
	#写入网卡IP地址
	#记录网卡设备号
	net_dev=0
	for ip in `awk -v a=$name 'a~$1{print $2}' hname.conf | sed 's/,/ /g'`
	do
		fix_eth $name $ip $net_dev
		net_dev=$(($net_dev+1))
	done
	
	#把改好的文件传到虚拟机里
#	virt-copy-in -a /var/lib/libvirt/images/Qiao-9.qcow2 /tmp/network /etc/sysconfig/
	virt-copy-in -a $disk_dir /tmp/hname/$name/hosts /etc
	virt-copy-in -a $disk_dir /tmp/hname/$name/network /etc/sysconfig
	rm -rf /tmp/hname/$name
	echo '完成'

done
echo -n "清理临时文件..."
rm -rf /tmp/hname
echo "完成。。"
