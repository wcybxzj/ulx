#!/bin/bash
#写入hosts解析文件
#fix_hosts $name $ip $pc_name
#fix_hosts 虚拟机名 ip地址 主机名
echo "开始上传hosts解析文件..."
fix_hosts(){
	echo "$2  $3" >> /tmp/hname/$1/hosts
}
mkdir -p /tmp/hname/mode &>/dev/null
cat > /tmp/hname/mode/hosts <<-EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
EOF
for i in `awk '{print $1}' vhost.conf`
do
	mkdir -p /tmp/hname/$i
	cp /tmp/hname/mode/hosts /tmp/hname/$i/hosts
	# 生成hosts解析文件
	for host_name in `awk '{print $3}' vhost.conf`
	do
		for h_ip in `awk -v a=$host_name 'a==$3{print $2}' vhost.conf | sed 's/,/ /g'`
		do
			fix_hosts $i $h_ip $host_name
		done 
	done
	ip_addr=`cat vhost.conf | awk -v a=$i 'a==$1{print $2}' | sed 's/,/\n/g' | head -n 1`
	echo -n "$ip_addr..."
	expect -c " 
	spawn scp /tmp/hname/$i/hosts $ip_addr:/etc/hosts
	expect { 
		 \"*yes/no*\" { exp_send \"yes\r\"; exp_continue}
		 \"*password:\" {send \"$ssh_pass\r\"}
		}
	interact" &> /dev/null
	echo "完成"
done
