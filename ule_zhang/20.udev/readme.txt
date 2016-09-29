udev简单使用
实验vmware
==========================================================================
实验1:给u盘改名为,my_u
1.vmware插u盘
fdisk -l sdc存在
ll /dev/sdc 存在

2.udevadm info --attribute-walk --name=sdc
SUBSYSTEMS=="usb"
ATTRS{serial}=="C8600088614CEF71BA105174"

3./etc/udev/rules.d/99-z-my.rules
SUBSYSTEMS=="usb",ATTRS{serial}=="C8600088614CEF71BA105174",NAME="my_u"

4.
fdisk -l sdc不存在
ll /dev/sdc 不存在
ll /dev/my_u 存在
==========================================================================
实验2:使用udev给u盘,做类似/dev/sr0->/dev/cdrom的效果
/etc/udev/rules.d/99-z-my.rules:
SUBSYSTEMS=="usb",ATTRS{serial}=="C8600088614CEF71BA105174",SYMLINK+="mymy_u"

执行:start_udev
fdisk -l sdc存在
ll /dev/sdc 存在
ll /dev/mymy_u 
lrwxrwxrwx. 1 root root 3 Jul 18 12:18 /dev/mymy_u -> sdc
==========================================================================
实验3:u盘插入后自动格式化,并且挂载到mnt:(没成功,放弃)
/etc/udev/rules.d/99-z-my.rules:
SUBSYSTEMS=="usb",ATTRS{serial}=="C8600088614CEF71BA105174",ACTION=="add",RUN+="/sbin/mkfs.vfat /dev/%k",RUN+="/bin/mount /dev/%k /mnt"
执行:start_udev
