#!/bin/bash
images_dir=/var/lib/libvirt/images
xml_dir=/etc/libvirt/qemu
base_img=centos6_base.qcow2


menu(){
cat <<EOF
	1.install centos6 kvm
	2.uninstall kvm
	m.display menu
EOF
}

menu

while :
do
read -p "plz enter[1-2], 显示菜单[m]:" choice
case $choice in
1)
	#yum
        if [ ! -f /etc/yum.repos.d/centos.repo ];then
                #rm -rf /etc/yum.repos.d/*
                wget -O /etc/yum.repos.d/centos.repo ftp://192.168.91.11/centos.repo &>/dev/null
        fi
	
	#libvirtd
	service libvirtd status &>/dev/null
	if [ $? -ne 0 ];then
		yum install -y "virtual*"
		sleep 5
		service libvirtd start
		chkconfig libvirtd on
	fi
	
	#base_img
        if [ ! -f ${images_dir}/$base_img ];then
                echo "正在下载镜像文件，请稍候......"
                wget -O ${images_dir}/$base_img ftp://192.168.91.11/myvms/$base_img &>/dev/null
        fi

	#xml
	rm -rf  ${xml_dir}/centos6_*.xml
	wget -P ${xml_dir}  ftp://192.168.91.11/myvms/xml/centos6_*.xml
	chmod 644 ${xml_dir}/*.xml

        for i in {1..10}
        do
                qemu-img create -f qcow2 -b ${images_dir}/${base_img} \
				${images_dir}/centos6_${i}.qcow2 &>/dev/null
                virsh define ${xml_dir}/centos6_${i}.xml &>/dev/null
                echo "已安装虚拟机 centos6_${i}......"
        done
	virsh define ${xml_dir}/centos6_base.xml &>/dev/null
	echo "已安装虚拟机 centos6_base......"
	;;
2)
	rm -rf  ${xml_dir}/centos*.xml
        for i in {1..10}
        do
                vm_name=centos6_${i}
                virsh destroy ${vm_name} &>/dev/null
                virsh undefine ${vm_name} &>/dev/null
                rm -rf ${images_dir}/${vm_name}.qcow2
        done
	virsh destroy centos6_base
	virsh undefine centos6_base
	rm -rf ${images_dir}/${base_img}

        for i in {1..10}
        do
                vm_name=centos-${i}
                virsh destroy ${vm_name} &>/dev/null
                virsh undefine ${vm_name} &>/dev/null
                rm -rf ${images_dir}/${vm_name}.qcow2
        done
	rm -rf ${images_dir}/centos6u6_base.qcow2

;;
m)
	clear
	menu
	;;
*)
	echo "输入错误"
	menu
	read -p "plz enter[1-2], 显示菜单[m]:" choice
	;;
esac
done



