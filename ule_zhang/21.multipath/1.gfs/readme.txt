============================================================================================
============================================================================================
============================================================================================
实验1:此实验和udev中gfs一样，只是不用udev用的multipath
============================================================================================
============================================================================================
============================================================================================
192.168.122.101 iscsi101.uplooking.com
192.168.122.110 iscsi110.uplooking.com
192.168.122.102 web102.uplooking.com
192.168.122.103 web103.uplooking.com
192.168.100.101 iscsi101.uplooking.com
192.168.100.110 iscsi110.uplooking.com
192.168.100.102 web102.uplooking.com
192.168.100.103 web103.uplooking.com
============================================================================================
iscsi1 iscsi2:
分别做200M
dd if=/dev/zero of=/mysan1 bs=100M count=2
dd if=/dev/zero of=/mysan2 bs=100M count=2

yum install scsi-target-utils -y

service tgtd start
chkconfig tgtd on
============================================================================================
web102 web103:
yum install iscsi-initiator-utils -y
iscsiadm -m discovery -t sendtargets -p 192.168.122.101
iscsiadm -m discovery -t sendtargets -p 192.168.100.101
iscsiadm -m discovery -t sendtargets -p 192.168.122.110
iscsiadm -m discovery -t sendtargets -p 192.168.100.110

iscsiadm -m node -T iqn.2012-02.com.uplooking:Storage1.target1 -l
iscsiadm -m node -T iqn.2012-02.com.uplooking:Storage1.target2 -l

yum install device-mapper-multipath
mpathconf --user_friendly_names y --find_multipaths y --with_multipathd y --with_chkconfig y
service multipathd start
chkconfig multipathd on
multipath -ll
============================================================================================
web102:
本地LVM
yum install -y lvm2-2.02.111-2.el6.x86_64
pvcreate /dev/mapper/mpatha
pvcreate /dev/mapper/mpathb
vgcreate vgiscsi /dev/mapper/mpatha /dev/mapper/mpathb
lvcreate -L 300M -n lviscsi vgiscsi
============================================================================================
web102 web103:
密码luci创建集群要用
yum install ricci -y
yum install cman -y
service rgmanager restart

passwd ricci
123

service ricci restart
service cman restart
service rgmanager restart

chkconfig ricci on
chkconfig cman on
chkconfig rgmanager on
============================================================================================
iscsi101:
service luci start
chkconfig luci on
https://iscsi101.uplooking.com:8084/ 创建集群 apache-cluster
如果之前lucci安装过 造成在web不能创建集群 rm /etc/cluster/cluster.conf
集群名:apache-cluster
============================================================================================
8.web102:clvm
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

mkdir /iscsi

mount -t gfs2 -o lockproto=lock_dlm /dev/vgiscsi/lviscsi /iscsi

yum install lvm2-cluster -y
lvmconf --enable-cluster
service clvmd restart
chkconfig clvmd on

==============================================================================
vim /etc/rc.local
vgchange -ay vgiscsi
==============================================================================
测试1:
web2 web3两边读写是互通的
测试2:
udev 让web2 web3增加硬盘不会影响到lvm
因为iscsi共享过来的都是sdx,这里加的硬盘kvm中用IDE

============================================================================================
============================================================================================
============================================================================================
实验2:根据实验1的基础上扩容iscsci服务端
============================================================================================
============================================================================================
============================================================================================
192.168.122.101 iscsi101.uplooking.com
192.168.122.110 iscsi110.uplooking.com
192.168.122.102 web102.uplooking.com
192.168.122.103 web103.uplooking.com
192.168.100.101 iscsi101.uplooking.com
192.168.100.110 iscsi110.uplooking.com
192.168.100.102 web102.uplooking.com
192.168.100.103 web103.uplooking.com
192.168.100.104 web104.uplooking.com
192.168.122.104 web104.uplooking.com
192.168.100.105 iscsi105.uplooking.com
192.168.122.105 iscsi105.uplooking.com
================================================================
1.新增存储节点
iscsi105:
yum install -y scsi-target-utils
dd if=/dev/zero of=/mysan3 bs=1M count=400
vim /etc/tgt/targets.conf
<target iqn.2012-02.com.uplooking:Storage1.target3>
        backing-store /mysan3
        scsi_id s3
        initiator-address 192.168.122.102
        initiator-address 192.168.100.102
        initiator-address 192.168.122.103
        initiator-address 192.168.100.103
        initiator-address 192.168.122.104
        initiator-address 192.168.100.104
</target>

service tgtd start
chkconfig tgtd on
============================================================================================
2.web102&web103使用新iscsi节点
web102 web103:
yum install iscsi-initiator-utils -y
iscsiadm -m discovery -t sendtargets -p 192.168.122.105
iscsiadm -m discovery -t sendtargets -p 192.168.100.105
iscsiadm -m node -T iqn.2012-02.com.uplooking:Storage1.target3 -l

yum install -y device-mapper-multipath
mpathconf --user_friendly_names y --find_multipaths y --with_multipathd y --with_chkconfig y
service multipathd restart
chkconfig multipathd on
multipath -ll
fdisk -l
multipath 识别新的共享存储/dev/mapper/mpathc

扩容LVM到500M
pvcreate /dev/mapper/mpathc
vgextend vgiscsi /dev/mapper/mpathc
lvextend -L 500M /dev/vgiscsi/lviscsi
mount -t gfs2 -o lockproto=lock_dlm /dev/vgiscsi/lviscsi /iscsi
gfs2_grow -v /iscsi
============================================================================================
3.新增客户端(不成功)
web104:
yum install iscsi-initiator-utils -y

iscsiadm -m discovery -t sendtargets -p 192.168.122.105
iscsiadm -m discovery -t sendtargets -p 192.168.100.105
iscsiadm -m discovery -t sendtargets -p 192.168.122.101
iscsiadm -m discovery -t sendtargets -p 192.168.100.101
iscsiadm -m discovery -t sendtargets -p 192.168.122.110
iscsiadm -m discovery -t sendtargets -p 192.168.100.110

iscsiadm -m node -T iqn.2012-02.com.uplooking:Storage1.target1 -l
iscsiadm -m node -T iqn.2012-02.com.uplooking:Storage1.target2 -l
iscsiadm -m node -T iqn.2012-02.com.uplooking:Storage1.target3 -l

yum install -y device-mapper-multipath
mpathconf --user_friendly_names y --find_multipaths y --with_multipathd y --with_chkconfig y
service multipathd start
chkconfig multipathd on
multipath -ll

yum install -y lvm2-2.02.111-2.el6.x86_64

yum install ricci -y
yum install cman -y
yum rgmanager -y

passwd ricci
123

service ricci restart
service cman restart
service rgmanager restart

chkconfig ricci on
chkconfig cman on
chkconfig rgmanager on

在luci的web加上web104.uplooking.com到集群中

vim /etc/rc.local
vgchange -ay vgiscsi

service cman status
yum install gfs2-utils -y
modprobe gfs2
lsmod | grep gfs2
mkdir /iscsi
mount -t gfs2 -o lockproto=lock_dlm /dev/vgiscsi/lviscsi /iscsi
gfs_controld join connect error: Connection refused
error mounting lockproto lock_dlm

web102:
gfs2_tool journals /iscsi
gfs2_jadd -j 1 /iscsi

web104:
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

mkdir /iscsi

mount -t gfs2 -o lockproto=lock_dlm /dev/vgiscsi/lviscsi /iscsi

vim /etc/init.d/cman
CMAN_QUORUM_TIMEOUT=45


yum install lvm2-cluster -y
lvmconf --enable-cluster
service clvmd restart
chkconfig clvmd on
