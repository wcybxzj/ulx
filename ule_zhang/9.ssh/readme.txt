端口转发:
192.168.91.3<----192.168.91.11<-------192.168.91.12
方法1:

192.168.91.11:
本地6300转发到192.168.91.3:22
ssh -CfNg -L 6300:127.0.0.1:22 root@192.168.91.3

192.168.91.12: 
通过91.11的6300直接登陆到91.3
sh 192.168.91.11 -p 6300

http://www.cnblogs.com/wangkangluo1/archive/2011/06/29/2093727.html

---------------------------------------------------------------------
方法2:

192.168.91.3:
使用 -R 标记将 91.11上端口 2222 的转发到 91.3的端口 22 上。
ssh -R 2222:localhost:22 192.168.91.11

192.168.91.11:
while [ 1 ]; do date; sleep 300; done

192.168.91.12:
ssh 192.168.91.11
通过91.11的2222直接登陆到91.3
ssh -p 2222 127.0.0.1

https://www.ibm.com/developerworks/cn/linux/l-10sysadtips/
