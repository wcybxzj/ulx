创建Linux镜像模板

脚本1:ks+virt-install 自动安装一个系统
     还要手动转换一下格式成qcow2
脚本2:配置系统,做为后端镜像使用
脚本3:创建xml,子系统
脚本4:批量 安装/卸载kvm脚本

========================================================================================
0.安装虚拟机
qcow2
磁盘size 20G

镜像模板
1. network
    /etc/init.d/NetworkManager stop
    chkconfig NetworkManager off
                                
    >/etc/udev/rules.d/70-persistent-net.rules
                                
    vim /etc/sysconfig/network-scripts/ifcfg-eth0 (删除mac,uuid)
    vim /etc/sysconfig/network-scripts/ifcfg-eth1 (删除mac,uuid)                   

2. yum configure 
   
3. iptables/selinux
    iptables -F
    service iptables save

4. 配置本地console连接
    vim /boot/grub/grub.conf
    kernel /vmlinuz-2.6.18-308.el5 ro root=/dev/VolGroup00/LogVol00 rhgb quiet console=ttyS0

6. ssh连接慢
   # vim /etc/ssh/sshd_config
   UseDNS no
   GSSAPIAuthentication no

    centos6u6.img   
    chattr +i centos6u6.img
    注：不能使用该镜像启动系统
    <graphics type='vnc' port='-1' autoport='yes' listen='0.0.0.0' keymap='en-us'>
参考: 
tianyun_ULA:创建Linux镜像模板
ULA-robin:KVM基本命令

==========================================================================================
如果前面不是qcow2安装的系统必须转成qcow2，因为这个原始系统要做后端镜像
cd /var/lib/libvirt/images
qemu-img convert -f raw -O qcow2 centos6.6_base.img centos6.6_base.qcow2
qemu-img info centos6.6_base.qcow2

virt-manager删除硬盘重新添加新格式的硬盘并删除centos6.6_base.img
