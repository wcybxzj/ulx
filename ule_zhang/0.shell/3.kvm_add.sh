#!/bin/bash
echo "已存在的虚拟机有:"
virsh list --all|sed '/^$/d'|awk 'NR>2 {printf $2" "}';
echo;
read -p "请输入添加的虚拟机名称(以空格分开): " Name
for cm1 in $Name
do
	cn=`echo $Name|sed "s/ /\n/g"|grep -c "\<$cm1\>"`;
	[ $cn -gt 1 ] && echo "您输入的虚拟机名字\"${cm1}\"有重复，请重新开始！" && exit;
done
for cm2 in $Name
do
	[ -f /etc/libvirt/qemu/${cm2}.xml ] && echo "您要创建的虚拟机\"${cm2}\"已存在，请另改名字重新开始！" && exit;
done
read -p "请问是否要手动输入模板的信息,如有多个模板建议手动输入(y/n): " sn
if [ $sn = y ];then
	echo "已存在的虚拟机磁盘文件有:"
	ls /var/lib/libvirt/images/;
	read -p "请输入模板虚拟机磁盘文件名称: " M_disk
	M_name=`grep -rl $M_disk /etc/libvirt/qemu|awk -F '[u][/]|[.]' '{print $2}'`;
elif [ $sn = n ];then
	echo "正在自动搜索模板信息...";
	M_disk=`ls -l /var/lib/libvirt/images/|grep ^[-]|awk '{print $5,$9}'|sort -n|tail -1|awk '{print $2}'`;
	 [ -n $M_disk ] &&  echo "找到模板磁盘文件：${M_disk}";
	M_name=`grep -rl $M_disk /etc/libvirt/qemu|awk -F '[u][/]|[.]' '{print $2}'`;
	 [ -n $M_name ] &&  echo "找到模板磁盘文件对应的模板配置文件：${M_name}.xml";
fi
qemu-img info /var/lib/libvirt/images/$M_disk | grep "format: qcow2" &> /dev/null ;
if [ $? -ne 0 ];then
	read -p "发现模板磁盘文件不是qcow2格式，是否转换(y/n): " pd;
	if [ $pd = y ];then
		NM_disk=muban.qcow2;
		qemu-img convert -f raw  -O qcow2 /var/lib/libvirt/images/$M_disk /var/lib/libvirt/images/$NM_disk &> /dev/null;
		M_disk=$NM_disk;
		gs=qcow2;
	else
		gs=raw;
	fi
else
	gs=qcow2;
fi
for i in $Name
do
	qemu-img create -f qcow2 -b /var/lib/libvirt/images/$M_disk /kvm/${i}.img &> /dev/null;
	virsh dumpxml $M_name > /etc/libvirt/qemu/${i}.xml;
	sed -r -i "s/(<name>).*(<\/name>)/\1$i\2/" /etc/libvirt/qemu/${i}.xml;
	sed  -i '/<uuid>/d' /etc/libvirt/qemu/${i}.xml;
	sed  -r -i "s/(raw)(' )(cache)/qcow2\2\3/" /etc/libvirt/qemu/${i}.xml;
	sed -r -i "/source file/c<source file='/kvm/${i}.img'/>" /etc/libvirt/qemu/${i}.xml;
	sed  -i '/mac address/d' /etc/libvirt/qemu/${i}.xml;
	virsh define /etc/libvirt/qemu/${i}.xml &> /dev/null;
	[ $? = 0 ] && echo "$i 添加成功！"  || echo "$i 添加失败！";
done
