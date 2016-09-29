5台机器
1台apache做前端,加tomcat负载均衡模块
192.168.122.101

2台httpd+tomcat
192.168.122.110
192.168.122.102

2台memcache
192.168.122.103
192.168.122.104
====================================================================================
apache:
yum install httpd httpd-devel
echo "apache" > /www/html/index.html
cd /tmp
tar zxvf tomcat-connectors-1.2.32-src.tar.gz
cd tomcat-connectors-1.2.32-src/native
./configure  --with-apxs=/usr/sbin/apxs
make && make install
cp   ../conf/httpd-jk.conf   /etc/httpd/conf.d/jk.conf

vim /etc/httpd/conf.d/jk.conf
LoadModule jk_module modules/mod_jk.so
JkMount    /*.jsp		wlb

cp ../conf/workers.properties /etc/httpd/conf

vim /etc/httpd/conf/workers.properties
追加
worker.list=wlb
worker.wlb.type=lb
worker.wlb.balance_workers=tomcat1,tomcat2
worker.tomcat1.type=ajp13
worker.tomcat1.host=192.168.122.110
worker.tomcat1.port=8009
worker.tomcat1.lbfactor=1
worker.tomcat2.type=ajp13
worker.tomcat2.host=192.168.122.102
worker.tomcat2.port=8009
worker.tomcat2.lbfactor=1

service httpd start
====================================================================================
部署 Tomcat 1 & Tomcat 2
yum install -y glibc-2.12-1.149.el6.i686
service httpd stop
cd /tmp
chmod +x jdk-6u27-linux-i586.bin
./jdk-6u27-linux-i586.bin
mv  jdk1.6.0_27/   /usr/local/jdk

vim /etc/bashrc
export JAVA_HOME=/usr/local/jdk
export JAVA_BIN=/usr/local/jdk/bin/
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_HOME JAVA_BIN PATH CLASSPATH

source /etc/bashrc
java -version

tar zxf apache-tomcat-6.0.32.tar.gz
mv apache-tomcat-6.0.32 /usr/local/tomcat
cd /usr/local/tomcat/bin
./startup.sh
vim /usr/local/tomcat/webapps/ROOT/index.jsp
<html>
	<body bgcolor="red"> 		#Tomcat2 修改为别的颜色
		<center>
		<%= request.getSession().getId() %>
		<h1>Tomcat 1</h1> #Tomcat 2
	</body>
</html>

阶段测试
1.访问 http://192.168.122.101/index.html 由 Aapche 处理,
2.访问 http://192.168.122.101/index.jsp 交给 Tomcat 1 与 Tomcat 2 负载处理,
3.访问 http://192.168.122.101/index.jsp 时在 Tomcat 1 与 Tomcat 2 之间进行切换,但是 session_id
也随之变化

====================================================================================
部署 Memcache 1 & Memcache 2
tar xf libevent-2.0.15-stable.tar.gz
cd libevent-2.0.15-stable
./configure --prefix=/usr/local/libevent && make && make install

echo /usr/local/libevent/lib/ > /etc/ld.so.conf.d/libevent.conf 
cat /etc/ld.so.conf.d/libevent.conf
ldconfig -v

tar xf memcached-1.4.5.tar.gz
cd memcached-1.4.5
./configure --prefix=/usr/local/memcache --with-libevent=/usr/local/libevent  && make && make install
/usr/local/memcache/bin/memcached  -h

192.168.122.103:
/usr/local/memcache/bin/memcached -p 11211 -l 192.168.122.103 -u root -m 10 -c 10 -vvv -f 1.2 -n 60

192.168.122.104:
/usr/local/memcache/bin/memcached -p 11211 -l 192.168.122.104 -u root -m 10 -c 10 -vvv -f 1.2 -n 60

====================================================================================

部署 Tomcat 1 & Tomcat 2 支持连接 Memcached
cp   session/*.jar   /usr/local/tomcat/lib
vim /usr/local/tomcat/conf/context.xml
<Manager
className="de.javakaffee.web.msm.MemcachedBackupSessionManager"
		memcachedNodes="n1:192.168.122.40:11211,n2:192.168.122.50:11211"
		failoverNodes="n1"
		requestUriIgnorePattern=".*\.(ico|png|gif|jpg|css|js)$"
		transcoderFactoryClass="de.javakaffee.web.msm.serializer.kryo.KryoTranscoderFactory"
/>
注意：定义内容要写在<Context></Context>里面
/usr/local/tomcat/bin/shutdown.sh
/usr/local/tomcat/bin/startup.sh

最终测试
1.访问 index.html 由 Aapche 处理,
2.访问 index.jsp 交给 Tomcat 1 与 Tomcat 2 负载处理,
3.访问 index.jsp 时在 Tomcat 1 与 Tomcat 2 之间进行切换,并且 session_id 不会变化
