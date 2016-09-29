实验1:多路冗余:
10.10.10.8 s8.uplooking.com iscsi服务端
10.10.10.9 web9.uplooking.com iscsi客户端

s8:
eth0: inet 192.168.100.8/24 brd 192.168.100.255 scope global eth0
eth1: inet 10.10.10.8/24 brd 10.10.10.255 scope global
web9:
eth0: inet 192.168.100.9/24 brd 192.168.100.255 scope global eth0
eth1: inet 10.10.10.9/24 brd 10.10.10.255 scope global eth1

s8:用2个网线共享一个网络存储设备
web9:上识别把这种2个线路过来的1个设备当成2个设备
web9:上安装mutlipath通过设备映射把识别成2个的设备同一网络共享设备再次识别成1个
==================================================================================
具体操作:
==================================================================================
s8:
配置 ISCSI Storage
[root@localhost ~]# yum install scsi-target-utils
[root@localhost ~]# vim /etc/tgt/targets.conf 
<target iqn.2013-08.com.uplooking:iscsi.target1>
        backing-store /mysan
        vendor_id iscsi
        product_id storage1
        initiator-address 10.10.10.9
        initiator-address 192.168.100.9
</target>
service tgtd restart
chkconfig tgtd on
==================================================================================
web9:
yum install iscsi-initiator-utils
service iscsi start
chkconfig iscsi on
iscsiadm -m discovery -t sendtargets -p 10.10.10.8
iscsiadm -m discovery -t sendtargets -p 192.168.100.8

iscsiadm -m node -T iqn.2013-08.com.uplooking:iscsi.target1 -l
Logging in to [iface: default, target: iqn.2013-08.com.uplooking:iscsi.target1, portal: 192.168.100.8,3260] (multiple)
Logging in to [iface: default, target: iqn.2013-08.com.uplooking:iscsi.target1, portal: 10.10.10.8,3260] (multiple)
Login to [iface: default, target: iqn.2013-08.com.uplooking:iscsi.target1, portal: 192.168.100.8,3260] successful.
Login to [iface: default, target: iqn.2013-08.com.uplooking:iscsi.target1, portal: 10.10.10.8,3260] successful.

fdisk -l: 登陆1次出现2个新设备

yum install device-mapper-multipath
mpathconf --user_friendly_names y --find_multipaths y --with_multipathd y --with_chkconfig y
service multipathd start
chkconfig multipathd on

ll /dev/mapper/mpatha
lrwxrwxrwx. 1 root root 7 Aug 27 14:54 /dev/mapper/mpatha -> ../dm-0

multipath -ll
mpatha (1IET     00010001) dm-0 iscsi,storage1
size=300M features='0' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=1 status=active
| `- 3:0:0:1 sda 8:0   active ready running
`-+- policy='round-robin 0' prio=1 status=enabled
  `- 2:0:0:1 sdb 8:16  active ready running
这种模式是主备模式,
status是active的是正在运行的线路
status是enabled的是正在运行的线路
==================================================================================
测试1:对挂载分区写入，tcpdump查看是否是一个网卡在工作
web9:
为了测试给eth1 加1个临时ip用于ssh
ip addr add dev eth1 10.10.10.99/24
窗口1:
mkfs.ext4 /dev/mapper/mpatha 
mount /dev/mapper/mpatha /mnt
php 1.php
<?php
while(1){
	system("dd if=/dev/zero of=/mnt/1.txt bs=1M count=300");
	echo "1";
	sleep(1);
}

窗口2:
[root@web9 ~]# tcpdump -i eth0 host 192.168.100.9

窗口3:
[root@web9 ~]# tcpdump -i eth1 -nn host 10.10.10.9
==================================================================================
测试2:切断正在工作的线路查看情况
web9:
上边是10.10.10.9是工作线路所以 ifdown eth1 查看工作情况是否正常
对于/mnt的读写会中断大约5分钟，回复后切换到192.168.100.9线路
[root@web9 ~]# multipath -ll
mpatha (1IET     00010001) dm-0 iscsi,storage1
size=300M features='0' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=0 status=enabled
| `- 3:0:0:1 sda 8:0   failed faulty running
`-+- policy='round-robin 0' prio=1 status=active
  `- 2:0:0:1 sdb 8:16  active ready  running
==================================================================================
测试3:改变多路径策略成为多线路负载均衡模式(没成功 放弃)
multipath -F        # 刷新所有的多路径设备映射
multipath -p multibus -v0  # 切换成负载均衡模式
multipath -ll
mpatha (1IET
00010001) dm-0 IET,VIRTUAL-DISK
size=2.0G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
|- 2:0:0:1 sda 8:0 active ready running
`- 3:0:0:1 sdb 8:16 active ready running
如果成功你会发现它会根据轮叫方式调度链路 sda 和 sdb,从而实现负载均衡。
==================================================================================
测试4:给web9加一个IDE硬盘
多路冗余共享过来的存储不受影响
