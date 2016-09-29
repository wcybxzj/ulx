实验1:vip+nfs+httpd 最基本的HA

luci+nfs:
	service nfs start
	chkconfig nfs on
	service luci start
	chkconfig luci on

ricci+cman+rgmanager:
	service ricci start
   	chkconfig ricci on
   	service cman start
   	chkconfig cman on
   	service rgmanager start
   	chkconfig rgmanager on

