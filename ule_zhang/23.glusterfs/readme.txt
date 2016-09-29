环境:
4台gluster node节点
192.168.122.101
192.168.122.110
192.168.122.102
192.168.122.103

1台client节点
192.168.122.109
=================================================
服务节点:
yum install -y glusterfs-*
/etc/init.d/glusterd restart

gluster peer probe 192.168.122.110
gluster peer probe 192.168.122.102
gluster peer probe 192.168.122.103
gluster peer status

删除node
gluster volume remove-brick datav1 staus
gluster volume remove-brick datav1 192.168.122.103:/data start
gluster volume remove-brick datav1 192.168.122.103:/data commit

增加node
gluster volume add-brick datav1 192.168.122.103:/data1 force

平衡节点数据量:
gluster volume rebalance  datav1 start
gluster volume rebalance  status
============================================================
分布卷
gluster volume create datav1 transport tcp 192.168.122.101:/data1 \
					   192.168.122.110:/data1 \
					   192.168.122.102:/data1 \
					   192.168.122.103:/data1 force
gluster volume start datav1
gluster volume status 
gluster volume info
============================================================
3种客户端使用方式:
无论那种挂载方式,互相信息是一致的

client原生文件系统挂载 
mount -t glusterfs 192.168.122.101:/datav1 /mnt
touch {1..100}.txt
============================================================
gluster 原生nfs挂载
所有服务节点:
service rpcbind start
service nfs stop

客户端执行
[root@node109 /]# mount -t nfs  iscsi101.uplooking.com:/datav1 /mnt
mount.nfs: rpc.statd is not running but is required for remote locking.
mount.nfs: Either use '-o nolock' to keep locks local, or start statd.
mount.nfs: an incorrect mount option was specified

sudo /sbin/service rpcbind start
sudo /sbin/service nfslock start
============================================================
使用系统NFS挂载：没成功放弃

192.168.122.110:
首先把卷使用glusterfs方法挂载到某个目录
mount -t glusterfs 192.168.122.110:/datav1 /mnt

vim /etc/exports
/mnt *(rw)
然后停掉原生NFS：
gluster volume set datav1 nfs.disable on

最后再启动系统NFS服务即可
for i in {101,110,102,103}; do ssh 192.168.122.$i "service nfs restart; gluster volume status"; done

192.168.122.109:
showmount -e 192.168.122.101
mount -t nfs -o vers=4  192.168.122.110:/mnt  /mnt 
ll /mnt 但是 gluster server cpu跑满暴了一堆错误
