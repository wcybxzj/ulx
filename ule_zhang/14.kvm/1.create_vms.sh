#!/bin/bash
images_dir=/var/lib/libvirt/images/
#etc_dir=/etc/libvirt/qemu/
etc_dir=/var/ftp/myvms/xml

service libvirtd status &>/dev/null
if [ $? -ne 0 ];then
	yum install -y "virtual*"
	sleep 5
	service libvirtd start
	chkconfig libvirtd on
fi

#创建xml
for i in {1..10}
do
	cp -f ${etc_dir}/centos6_base.xml ${etc_dir}/centos6_$i.xml
done

#修改xml
#uuid
#name
#source_file
#mac
for i in {1..10}
do
	sed -r -i "s/_base/_$i/g" ${etc_dir}/centos6_$i.xml
	sed -r -i '/<uuid>/d' ${etc_dir}/centos6_$i.xml 
	sed -r -i '/<mac /d' ${etc_dir}/centos6_$i.xml 
done

#define kvm
#for i in {1..10}
#do
#	virsh define ${etc_dir}/centos6_$i.xml
#done

echo 'install finshed'
