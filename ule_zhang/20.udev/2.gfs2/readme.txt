web2  最少给800M 创建gfs2文件格式很消耗内存
10.10.10.1 iscsi1.uplooking.com
10.10.10.254 iscsi2.uplooking.com
10.10.10.2 web2.uplooking.com
10.10.10.3 web3.uplooking.com
===============================================================================
1.iscsi1:
dd if=/dev/zero of=/mysan1 bs=100M count=10
iscsi2:
dd if=/dev/zero of=/mysan2 bs=100M count=10
===============================================================================
2.iscsi1&iscsi2:
vim /etc/tgt/targets.conf写规则
service tgtd restart 
tgt-admin --force --update ALL
tgt-admin --show
===============================================================================
3.web2:
iscsiadm -m discovery -t sendtargets -p 10.10.10.1:3260
iscsiadm -m discovery -t sendtargets -p 10.10.10.254:3260

iscsiadm -m node -T iqn.2013-06.com.tianyun:san1 -l
iscsiadm -m node -T iqn.2013-06.com.tianyun:san2 -l

fdisk -l
看到新设备
===============================================================================
4.web2:
查看规则写入/etc/udev/rule.d/99-my.rules
udevadm info --attribute-walk --name=sda
udevadm info --attribute-walk --name=sdb

/udev/rule.d/99-my.rules:
SUBSYSTEMS=="scsi",ATTRS{vendor}=="my_v1",ATTRS{model}=="my_p1",SYMLINK+="iscsi/mysan1"
SUBSYSTEMS=="scsi",ATTRS{vendor}=="my_v2",ATTRS{model}=="my_p2",SYMLINK+="iscsi/mysan2"

start_udev
===============================================================================
web3:
scp 10.10.10.2:/udev/rule.d/99-my.rules  /udev/rule.d/
start_udev
===============================================================================
5.web2:
本地LVM
yum install -y lvm2-2.02.111-2.el6.x86_64
pvcreate /dev/iscsi/mysan1
pvcreate /dev/iscsi/mysan2
vgcreate vgiscsi /dev/iscsi/mysan1 /dev/iscsi/mysan2
lvcreate -L 1200M -n lviscsi vgiscsi
===============================================================================
6.web2&web3
service ricci restart
service cman restart
service rgmanager restart

chkconfig ricci on
chkconfig cman on
chkconfig rgmanager on
===============================================================================
7.iscsi1:
service luci start
chkconfig luci on
http://10.10.10.1:8084/ 创建集群 apache-cluster
如果之前lucci安装过 造成在web不能创建集群 rm /etc/cluster/cluster.conf
===============================================================================
8.web2:clvm
service cman status
yum install gfs2-utils -y
modprobe gfs2 
lsmod | grep gfs2 
mkfs.gfs2 -t apache-cluster:table1 -p lock_dlm -j 2 /dev/vgiscsi/lviscsi
mkdir /iscsi
mount -t gfs2 -o lockproto=lock_dlm /dev/vgiscsi/lviscsi /iscsi 

yum install -y lvm2-cluster 
lvmconf --enable-cluster
service clvmd restart
chkconfig clvmd on 
===============================================================================
web3:
yum install iscsi-initiator-utils -y
yum install gfs2-utils -y
modprobe gfs2
lsmod | grep gfs2 
service iscsi start 

iscsiadm -m discovery -t sendtargets -p 10.10.10.1:3260
iscsiadm -m discovery -t sendtargets -p 10.10.10.254:3260

iscsiadm -m node -T iqn.2013-06.com.tianyun:san1 -l
iscsiadm -m node -T iqn.2013-06.com.tianyun:san2 -l

fdisk -l

pvscan

vgchange -ay vgiscsi

mkdir /iscsi

mount -t gfs2 -o lockproto=lock_dlm /dev/vgiscsi/lviscsi /iscsi 

yum install lvm2-cluster -y
lvmconf --enable-cluster 
service clvmd restart 
chkconfig clvmd on
===============================================================================
测试1:
web2 web3两边读写是互通的
测试2:
udev 让web2 web3增加硬盘不会影响到lvm
因为iscsi共享过来的都是sdx,这里加的硬盘kvm中用IDE


