实验:
1台iscsi共享2个存储
1台使用此共享存储,使用udev解决即使加了新ide硬盘也不影响原来的使用

===========================================================
0.准备sekinux关闭
10.10.10.254 iscsi target
10.10.10.2 iscsi initiator

1.target:
共享san1 san2

2.initiator:
如果先挂载san1识别成sda
挂载san2识别成sdb
相反
如果先挂载san2识别成sda
挂载san1识别成sdb

3.为了避免这种情况:
target:
写上san1 san2的特征
initiator:
据特征为san1 san2写udev规则无论kernel怎么识别
都会根据特征创建软连接保证不会错
===========================================================
1.target:
service tgtd restart
tgt-admin --force --update ALL
tgt-admin --show
chkconfig tgtd on

2.initiator:
可以看到随着登陆顺序kernel会把先登陆的iscsi设备挂载在前面甚至会变名字
通过下面3.udev规则用设备特征做了软连接避免了系统识别的名字不稳定造成的问题
chkconfig iscsid on
iscsiadm -m discovery -t st -p 10.10.10.254
iscsiadm -m node -T iqn.2013-06.com.tianyun:san1 -l
iscsiadm -m node -T iqn.2013-06.com.tianyun:san2 -l

ll /dev/mysan*
lrwxrwxrwx 1 root root 3 Jul 18 19:00 /dev/mysan1 -> sda
lrwxrwxrwx 1 root root 3 Jul 18 19:02 /dev/mysan2 -> sdb

iscsiadm -m node -T iqn.2013-06.com.tianyun:san1 -u
iscsiadm -m node -T iqn.2013-06.com.tianyun:san2 -u
rm -rf /var/lib/iscsi/*
tree /var/lib/iscsi/

iscsiadm -m discovery -t st -p 10.10.10.254
iscsiadm -m node -T iqn.2013-06.com.tianyun:san2 -l
iscsiadm -m node -T iqn.2013-06.com.tianyun:san1 -l

lrwxrwxrwx 1 root root 3 Jul 18 19:54 /dev/mysan1 -> sdd
lrwxrwxrwx 1 root root 3 Jul 18 19:54 /dev/mysan2 -> sdc


3.查看规则写入/etc/udev/rule.d/99-my.rules
udevadm info --attribute-walk --name=sda
udevadm info --attribute-walk --name=sdb

/udev/rule.d/99-my.rules:
SUBSYSTEMS=="scsi",ATTRS{vendor}=="my_v1",ATTRS{model}=="my_p1",SYMLINK+="mysan1"
SUBSYSTEMS=="scsi",ATTRS{vendor}=="my_v2",ATTRS{model}=="my_p2",SYMLINK+="mysan2"

start_udev

然后用udev中创建的软连接 进行格式化,挂载
避免使用系统识别出来的设备名称

mkfs.ext4 /dev/mysan1
mkfs.ext4 /dev/mysan2

mkdir /baidu /google

mount /dev/mysan1  /baidu
mount /dev/mysan2  /google

最后可以挂在httpd使用
