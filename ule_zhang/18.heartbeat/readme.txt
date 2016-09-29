实验1:
2个webserver做HA
主：pkill heartbeat fialover
=====================================

问题:
例如:httpd挂了
heartbeat没法对资源进行检测
keepalived可用脚本实现
conga本身就能实现

=====================================
看门狗:
soft dog
hard dog

解决问题: 
kill -9 heatbeat 不会failover
kvm susupend 不会failover
     

在所有heartbeat上安装
yum install -y watchdog
modprobe softdog
lsmod softdog
=====================================
1.脑裂实验
主:
iptables -A OUTPUT -j DROP 或者 iptables -A OUTPUT -p udp --dport 694 -j DROP
就出出现脑裂, iptable -F 恢复正常
或者
=====================================
实验2:hearbeat+lvs(没成功 放弃)
yum install -y heartbeat heartbeat-ldirectord perl-IO-Socket-INET6-2.56-4.el6
