#!/bin/bash
echo "[1] 配置YUM"
echo "[2] 安装KVM工具"
echo "[3] 设置桥接"
echo "[4] 手动安装虚拟机"
echo "[5] 查看虚拟机"
echo "[6] 开启虚拟机"
echo "[7] 关闭虚拟机"
echo "[8] 连接虚拟机"
echo "[9] 自动安装虚拟机"
echo "[0] 退出"
read -p "type:"  NUM
if [ $NUM = 0 ];then
exit;
elif [ $NUM = 1 ];then
#配置YUM
	rm -rf /etc/yum.repos.d/*;
cat > /etc/yum.repos.d/yum.repo << EOF
[yum]
name=yum
enabled=1
gpgcheck=0
baseurl=ftp://172.16.8.100/rhel6.4
EOF
elif [ $NUM = 2 ];then
#安装KVM工具
 	LANG=en yum groupinstall "Virtualization*" -y;
elif [ $NUM = 3 ];then
#设置桥接
	chkconfig NetworkManager off;
	chkconfig network on;
	service NetworkManager stop;
	service network start;
	yum install  "bridge-utils" -y;
	service libvirtd restart;
	chkconfig libvirtd on;
	virsh iface-bridge eth0 br0;
elif [ $NUM = 4 ];then
#安装虚拟机
	read -p "输入虚拟机的名字："  NAME
	read -p "输入虚拟及硬盘大小(G): "  SIZE
	read -p "输入虚拟机内存大小(M): "  MEM
	ping -c 1 172.16.8.100 > /dev/null
	if [ $? -ne 0 ];then
	echo "无法接连172.16.8.100，请检查网络！";
	exit;
	fi
	virt-install --nographics -n $NAME --os-type=linux --os-variant=rhel6 -r $MEM --arch=x86_64 --vcpus=1 --disk path=/var/lib/libvirt/images/$NAME,size=$SIZE,format=qcow2 -w bridge=br0 -l ftp://172.16.8.100/rhel6.4 -x "console=ttyS0";
elif [ $NUM = 5 ];then
#查看虚拟机
virsh list --all
elif [ $NUM = 6 ];then
#开机
read -p "虚拟机名称: " XNAME
virsh start $XNAME;
elif [ $NUM = 7 ];then
#关闭
read -p "虚拟机名称: " XNAME  &> /dev/null
virsh destroy $XNAME;
elif [ $NUM = 8 ];then
#连接虚拟机
read -p "虚拟机名称: " XNAME
virsh console $XNAME;
elif [ $NUM = 9 ];then
#自动安装虚拟机
read -p "输入虚拟机的名字："  NAME
        read -p "输入虚拟及硬盘大小(G): "  SIZE
        read -p "输入虚拟机内存大小(M): "  MEM
        ping -c 1 172.16.8.100 > /dev/null
        if [ $? -ne 0 ];then
        echo "无法接连172.16.8.100，请检查网络！";
        exit;
        fi
        virt-install --nographics -n $NAME --os-type=linux --os-variant=rhel6 -r $MEM --arch=x86_64 --vcpus=1 --disk path=/var/lib/libvirt/images/$NAME,size=$SIZE,format=qcow2 -w bridge=br0 -l ftp://172.16.8.100/rhel6.4 -x "console=ttyS0 ks=ftp://172.16.8.100/rhel6.4.ks";


else
echo "请输入:0~4数字!";
fi
