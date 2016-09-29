10.10.10.1 iscsci1.uplooking.com
10.10.10.4 web4.uplooking.com
========================================================
iscsi1:
yum install scsi-target-utils  -y
dd if=/dev/zero of=/mysan3 bs=100M count=1
dd if=/dev/zero of=/mysan4 bs=100M count=1
vim /etc/tgt/targets.conf
<target iqn.2013-06.com.tianyun:san3>
        backing-store /mysan3
        vendor_id my_v3
        product_id my_p3
        initiator-address 10.10.10.2
        initiator-address 10.10.10.3
        initiator-address 10.10.10.4
</target>
ervice tgtd restart
tgt-admin --force --update ALL

<target iqn.2013-06.com.tianyun:san4>
        backing-store /mysan4
        vendor_id my_v4
        product_id my_p4
        initiator-address 10.10.10.2
        initiator-address 10.10.10.3
        initiator-address 10.10.10.4
</target>

service tgtd start 
chkconfig tgtd on
========================================================
web4:
yum install iscsi-initiator-utils -y
service iscsi start 
chkconfig iscsi on
iscsiadm -m discovery -t st -p 10.10.10.1
iscsiadm -m node -T iqn.2013-06.com.tianyun:san3 -l
iscsiadm -m node -T iqn.2013-06.com.tianyun:san4 -l

pvcreate /dev/sda
pvcreate /dev/sdb
vgcreate vgtest  /dev/sda /dev/sdb
lvcreate -L 3000M -n lvtest vgtest
mkfs.ext4 /dev/vgtest/lvtest
mount /dev/vgtest/lvtest /mnt
echo  hahah > /mnt/haha.txt

特别注意:
只要是iscsi共享后在客户端做lvm，重启后web4就不无法识别到lvm的设备文件/dev/vgtest/lvtest就没了
办法:重新激活下lvm
/etc/rc.local:
vgchange -a y /dev/vgtest

只要这台机器加一块ide硬盘,重启一下 
共享的硬盘就会识别成sdb sdc,lvm就挂了,哪怕删除添加的硬盘lvm也无法恢复了

========================================================
web4:
解决办法办法用udev
先把之前pv vg lv都删了

vim /etc/udev/rules.d/99-my.rules
SUBSYSTEMS=="scsi",ATTRS{vendor}=="my_v3",ATTRS{model}=="my_p3",SYMLINK+="iscsi/mysan3"
SUBSYSTEMS=="scsi",ATTRS{vendor}=="my_v4",ATTRS{model}=="my_p4",SYMLINK+="iscsi/mysan4"

start_udev

iscsiadm -m node -T iqn.2013-06.com.tianyun:san3 -u
iscsiadm -m node -T iqn.2013-06.com.tianyun:san4 -u
rm -rf /var/lib/iscsi/*

iscsiadm -m discovery -t st -p 10.10.10.1
iscsiadm -m node -T iqn.2013-06.com.tianyun:san3 -l
iscsiadm -m node -T iqn.2013-06.com.tianyun:san4 -l

ll /dev/iscsi/mysan*
lrwxrwxrwx 1 root root 6 Jul 19 02:54 /dev/iscsi/mysan3 -> ../sda
lrwxrwxrwx 1 root root 6 Jul 19 02:54 /dev/iscsi/mysan4 -> ../sdb

pvcreate /dev/iscsi/mysan3
pvcreate /dev/iscsi/mysan4
vgcreate vgtest  /dev/iscsi/mysan3 /dev/iscsi/mysan4
lvcreate -L 190M -n lvtest vgtest
mkfs.ext4 /dev/vgtest/lvtest
mount /dev/vgtest/lvtest /mnt
echo  haha > /mnt/haha.txt

添加新ide硬盘或者iscsi新共享 引起内核识别硬盘名字改变也没关系
