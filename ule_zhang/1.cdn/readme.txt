CDN项目:
web4:
web5:
web6:
web7:
web8:
web9:
web10:

web5,web6:
有2个角色,省开2个虚拟机:client,httpd
client使用各自的DNS缓存服务器

web7,web8:
做DNS缓存转发服务器

web4:
DNS视图

web9,web10:
是squid反向代理各自的httpd
