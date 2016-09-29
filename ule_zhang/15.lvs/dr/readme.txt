client:
ip a:
virbr1(kvm 虚拟网络,host only):
inet 192.168.100.1/24 brd 192.168.100.255 scope global virbr1

ip r:
192.168.100.0/24 dev virbr1  proto kernel  scope link  src 192.168.100.1 
default via 192.168.91.2 dev br0 
=======================================================================
GW:
ip_forward 开启

ip a:
eth0:
192.168.100.254/24 brd 192.168.100.255 scope global eth0
eth1:
10.10.10.254/24 brd 10.10.10.255 scope global eth1

ip r:
192.168.100.0/24 dev eth0  proto kernel  scope link  src 192.168.100.254 
10.10.10.0/24 dev eth1  proto kernel  scope link  src 10.10.10.254 

iptables -t nat -L:
target     prot opt source               destination         
DNAT       tcp  --  anywhere             192.168.100.254     tcp dpt:http to:10.10.10.200:80
=======================================================================
director:
ip a:
eth0:
 inet 10.10.10.1/24 brd 10.10.10.255 scope global eth0
eth1:
 inet 10.10.10.200/24 brd 10.10.10.255 scope global eth1

ip r:
10.10.10.0/24 dev eth0  proto kernel  scope link  src 10.10.10.1 
10.10.10.0/24 dev eth1  proto kernel  scope link  src 10.10.10.200 
default via 10.10.10.254 dev eth0 
=======================================================================
realserver-web2:
arp_ignore:1 
arp_announce:2

ip a:
lo:
inet 127.0.0.1/8 scope host lo
inet 10.10.10.200/32 brd 10.10.10.200 scope host lo
eth0:
inet 10.10.10.2/24 brd 10.10.10.255 scope global eth0

ip r:
10.10.10.0/24 dev eth0  proto kernel  scope link  src 10.10.10.2 
default via 10.10.10.254 dev eth0


realserver-web3:同上
