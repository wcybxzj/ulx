#!/bin/bash

images_dir=/var/lib/libvirt/images
xml_dir=/etc/libvirt/qemu

mkdir -p /tmp/hname/mode
cat > /tmp/hname/mode/ifcfg-eth0 <<-EOF
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=dhcp
EOF

fix_eth(){
        cp -rf /tmp/hname/mode/ifcfg-eth0 /tmp/hname/$name/ifcfg-eth$3
        sed -i "s/eth0/eth$3/g" /tmp/hname/$1/ifcfg-eth$3
        sed -i /BOOTPROTO=/d /tmp/hname/$1/ifcfg-eth$3
        echo 'BOOTPROTO="static"' >> /tmp/hname/$1/ifcfg-eth$3
        sed -i /IPADDR=/d /tmp/hname/$1/ifcfg-eth$3
        echo "IPADDR=$2" >> /tmp/hname/$1/ifcfg-eth$3
        sed -i /PREFIX=/d /tmp/hname/$1/ifcfg-eth$3
        echo "PREFIX=24" >> /tmp/hname/$1/ifcfg-eth$3
        sed -i /GATEWAY=/d /tmp/hname/$1/ifcfg-eth$3
        # 如果为192.168.122.0网段，就写入对应的网关
        if [[ $2 = 192\.168\.122\.* ]]
                then
                echo "GATEWAY=192.168.122.1" >> /tmp/hname/$1/ifcfg-eth$3
        fi
	echo 'before virt-copy-in name:' $1
        virt-copy-in -a $disk_dir /tmp/hname/$1/ifcfg-eth$3 /etc/sysconfig/network-scripts
	echo 'finish virt-copy-in name:' $1
}

for name in `awk '{print $1}' vhost.conf`
do 
#{
        xml_name=`grep -R "<name>$name<\/name>" $xml_dir/* | awk -F: '{print $1}'`
        disk_dir=`cat $xml_name | grep $images_dir | head -1 | awk -F\' '{print $2}'`
        mkdir /tmp/hname/$name -p
        net_dev=0
        for ip in `awk -v a=$name 'a==$1{print $2}' vhost.conf | sed 's/,/ /g'`
        do
	{
		echo working on $name $ip $net_dev
                fix_eth $name $ip $net_dev
                net_dev=$(($net_dev+1))
	}
        done
#}&
done
#wait
echo 'all is done!!!'
