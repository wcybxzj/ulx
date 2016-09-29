#!/bin/bash
#kvm manager v1.0 
#by tianyun 04/28/2016
vm_image_dir=/var/lib/libvirt/images
location=ftp://172.16.8.100/rhel6.4
ks_file=ftp://172.16.8.100/rhel6.4.ks
back_image=/var/lib/libvirt/images/rhel6.4_base.qcow2
sample_xml=/etc/libvirt/qemu/sample.xml
down_back_image=ftp://172.16.8.100/vms/rhel6.4_base.qcow2
down_sample_xml=ftp://172.16.8.100/vms/sample.xml

main_menu() {
	cat <<-YANG
	+-------------------------------------------------------+
	|                                                       |
	|                  KVM 管理器 v1.0   	                |
	|		1. 安装虚拟化软件			|
	|		2. 自动安装虚拟机			|
	|		3. 批量部署Linux虚拟机			|
	|		4. 批量部署Windows虚拟机		|
	|		5. 恢复指定虚拟机			|
	|		6. 删除指定虚拟机			|
	|		h. 打印管理菜单				|
	|		q. 退出KVM管理器			|
	+-------------------------------------------------------+ 
	YANG
}

install_kvm_soft() {
	service libvirtd status &>/dev/null
	if [ $? -ne 0 ];then
		yum -y groupinstall "Virtualization*"
		service libvirtd start
		chkconfig libvirtd on				
		clear
		echo "kvm install finish..."
		main_menu
	else
		echo "kvm is running..." 
	fi
}

install_linux() {
	while true
	do
		read -p "请输入虚拟机name,cpu,mem[e.g. tianyun 1 512]: " vm_name vm_cpu vm_mem
		echo "你输入的虚拟机name: $vm_name"
		echo "你输入的虚拟机cpu: $vm_cpu"
		echo "你输入的虚拟机mem: $vm_mem"
		
		read -p "Are you sure? [q退出,h返回主菜单]: " action
		case "$action" in
		y|Y|yes|YES)
				/usr/sbin/virt-install \
				--graphics vnc \
				--name=$vm_name \
				--ram=$vm_mem \
				--vcpus=$vm_cpu \
				--arch=x86_64 \
				--os-type=linux \
				--os-variant=rhel6 \
				--hvm \
				--disk path=$vm_image_dir/${vm_name}.img,size=8,format=qcow2 \
				--bridge=virbr0 \
				--location=$location \
				--extra-args="ks=${ks_file}"		
				;;
		q)
				exit
				;;
		h)
				main_menu
				break	
				;;
		*)
				exit	
		esac	
	done
}

auto_install_linux() {
	read -p "请输入要安装虚拟机的前缀: " vm_prefix	
	read -p "请输入要安装虚拟机的数量: " vm_number

	if [ ! -f $back_image ];then
		echo "正在下载镜像，请稍候..."
		wget $down_back_image -O $back_image
	fi

	if [ ! -f $sample_xml ];then
		wget $down_sample_xml -O $sample_xml
	fi

	for i in `seq -w $vm_number`
	do
		{
		vm_name=${vm_prefix}$i
		vm_xml=${vm_name}.xml
		vm_uuid=`uuidgen`
		vm_image=$vm_image_dir/${vm_name}.qcow2
		vm_mac="52:54:$(dd if=/dev/urandom count=1 2>/dev/null \
		| md5sum | sed -r 's/^(..)(..)(..)(..).*$/\1:\2:\3:\4/')"

		qemu-img create -f qcow2 -b $back_image $vm_image &>/dev/null
		\cp -rf $sample_xml $vm_xml
		sed -ri "s#sample_name#$vm_name#" $vm_xml
		sed -ri "s#sample_uuid#$vm_uuid#" $vm_xml
		sed -ri "s#sample_image#$vm_image#" $vm_xml
		sed -ri "s#sample_mac#$vm_mac#" $vm_xml

		virsh define $vm_xml &>/dev/null
		echo "$vm_name 创建成功"
		}&
	done
	wait 
	echo "所有虚拟机创建完成."
}

main_menu

while :
do
	read -p "请选择相应的操作[q退出]: " choice
	case "$choice" in
	h|H)
		clear
		main_menu
		;;
	1)
		install_kvm_soft
		;;
	2)
		install_linux
		;;
	3)
		auto_install_linux
		;;	
	4)
		auto_install_windows
		;;
	5)
		rebuild_vm
		;;
	6)
		delete_vm
		;;
	q|Q)
		exit
		;;
	'')
		true
		;;
	*)
		echo "输入错误,重新输入"
	esac
done
