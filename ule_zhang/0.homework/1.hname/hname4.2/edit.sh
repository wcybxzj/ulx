#!/bin/bash

# xml文件名
# add_inter /etc/libvirt/qemu/Q1.xml
# $1
add_inter() {
	net_source=`awk -F\' '/source network/{print $2}' $1 | head -1`
	#echo $net_source
	insert_line=`awk '/\/interface/{print NR}' $1 | head -1`
	#echo $insert_line
	sed -i "${insert_line}a </interface>" $1
	sed -i "${insert_line}a    <source network='${net_source}'/>" $1
	sed -i "${insert_line}a <interface type='network'>" $1
}
# END add_inter()

# 硬盘放到最后添加，否则可能会影响写入配置文件。
# add_disk 虚拟机名，images路径，添加磁盘数量，磁盘大小,xml文件
# add_disk $name $images_dir $disk_num $disk_size 
add_disk() {
	#每次循环添加一块硬盘
	for ((i=0;i<$3;i++))
	do
		n=1
		while [ -f $2/$1-$n.qcow2 ]
		do
			n=$(($n+1))
		done
		#echo $2/$1-$n.qcow2
		qemu-img create -f qcow2 -o preallocation=metadata $2/$1-$n.qcow2 $4 &>/dev/null
		for j in {b..z}
		do
			grep "dev='vd"$j"'" $5 &>/dev/null
			if [ $? -ne 0 ]
			then
				virsh attach-disk $1 $2/$1-$n.qcow2 vd$j --persistent &>/dev/null
				if [ $? -eq 0 ]
				then
					echo "$1 vd$j 添加成功"
				else
					echo "$1 vd$j 添加失败"
				fi
				break
			fi
		done
	done
}
# END add_disk()

# 安装相关的软件包
install_tools(){
	echo -n "正在安装相关软件包..."
	yum install libguestfs-tools -y &>/dev/null
	rpm -q libguestfs-tools &>/dev/null
	if [ $? -ne 0 ]
	then 
		echo "安装失败，请检查yum仓库配置。。。"
		exit 1
	fi      
	echo "完成"
}
# END install_tools()

# 写入网卡IP地址
# fix_eth 虚拟机名 ip地址 eth(n)
# fix_eth $name $ip $n
fix_eth(){
	cp -rf /tmp/hname/mode/ifcfg-eth0 /tmp/hname/$name/ifcfg-eth$3
	sed -i "s/eth0/eth$3/g" /tmp/hname/$1/ifcfg-eth$3
	sed -i /BOOTPROTO=/d /tmp/hname/$1/ifcfg-eth$3
	echo 'BOOTPROTO="static"' >> /tmp/hname/$1/ifcfg-eth$3
	sed -i /IPADDR=/d /tmp/hname/$1/ifcfg-eth$3
	echo "IPADDR=$2" >> /tmp/hname/$1/ifcfg-eth$3
	sed -i /PREFIX=/d /tmp/hname/$1/ifcfg-eth$3
	echo "PREFIX=24" >> /tmp/hname/$1/ifcfg-eth$3
	sed -i /GATEWAY=/d /tmp/hname/$1/ifcfg-eth$3
	# 如果为192.168.122.0网段，就写入对应的网关
	if [[ $2 = 192\.168\.122\.* ]]
		then
		echo "GATEWAY=192.168.122.1" >> /tmp/hname/$1/ifcfg-eth$3
	fi
	virt-copy-in -a $disk_dir /tmp/hname/$1/ifcfg-eth$3 /etc/sysconfig/network-scripts
}
# END fix_eth()

install_tools

mkdir /tmp/hname/mode -p
cat > /tmp/hname/mode/ifcfg-eth0 <<-EOF
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=dhcp
EOF
cat > /tmp/hname/mode/network <<-EOF
RKING=yes
HOSTNAME=example.qiao.com
EOF

# 主循环，循环次数为虚拟机的个数
for name in `awk '{print $1}' vhost.conf`
do
	disk_num=`awk -v n=$name 'n==$1{print $4}' vhost.conf`
	#获得这台虚拟机的xml配置文件
	xml_name=`grep -R "<name>$name<\/name>" $xml_dir/* | awk -F: '{print $1}'`
	#获得这台虚拟机磁盘文件保存路径
	#disk_dir=`cat /etc/libvirt/qemu/Qiao-8.xml | grep $images_dir awk -F\' '{print $2}'`
	disk_dir=`cat $xml_name | grep $images_dir | head -1 | awk -F\' '{print $2}'`

	echo  "正在修改$name..."

	mkdir /tmp/hname/$name -p
	#拷贝配置文件
	#拷贝模板虚拟机的配置文件
	cp -rf /tmp/hname/mode/network /tmp/hname/$name

	#从配置文件中读取当前虚拟机的IP地址和主机名
#	ip=`awk -v n=$name '$1==n{print $2}' vhost.conf`
	host_name=`awk -v n=$name '$1==n{print $3}' vhost.conf`
	#写入主机名
	sed -i /HOSTNAME=/d /tmp/hname/$name/network
	echo "HOSTNAME=$host_name" >> /tmp/hname/$name/network
	#把改好的文件传到虚拟机里
#	virt-copy-in -a /var/lib/libvirt/images/Qiao-9.qcow2 /tmp/network /etc/sysconfig/
	virt-copy-in -a $disk_dir /tmp/hname/$name/network /etc/sysconfig

	#写入网卡IP地址
	#记录网卡设备号
	net_dev=0
	for ip in `awk -v a=$name 'a==$1{print $2}' vhost.conf | sed 's/,/ /g'`
	do
		fix_eth $name $ip $net_dev
		net_dev=$(($net_dev+1))
	done
	
	ip_num=`awk -v a=$name 'a==$1{print $2}' vhost.conf | sed 's/,/\n/g' | wc -l`
	#echo $ip_num
	#echo $xml_name
	# 根据用户填写的IP地址数量，添加网卡
	#echo "ip_num = $ip_num"
	#echo "xml_name= $xml_name"
	echo -n "正在添加$name网卡..."
	for ((i=1;i<ip_num;i++))
	do
		add_inter $xml_name
	done
	virsh define $xml_name &>/dev/null
	echo "完成"
	
	# 虚拟机名，images路径，添加磁盘数量，磁盘大小,xml文件
	# 硬盘放到最后添加，否则可能会影响写入陪在文件。
	# add_disk $name $images_dir $disk_num $disk_size 
	if [ ! -z $disk_num ]
	then
		add_disk $name $images_dir $disk_num $disk_size $xml_name
	fi

	echo -n "$name 完成"
	if [[ $auto_power = "on" ]]
	then
		echo "...自动开机"
		virsh start $name &>/dev/null
	else
		echo
	fi
done
#echo -n "清理临时文件..."
#rm -rf /tmp/hname
#echo "完成。。"
