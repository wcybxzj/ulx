邮件安装过程看EMOS里的mail服务器.docx
postfix+extmail

service postfix restart
service courier-authlib restart 
service courier-imap restart 
service saslauthd restart

extmail
mail.robin.com 是网站入口
创建域upup.com
还有三个账号
robin@upup.com
zorro@upup.com
nagios@upup.com

最后实现在web端和命令行随意发送
echo "this this mail body"|mail -s subject1 robin@upup.com

需要有个DNS解析你给用extmail创建的邮件域,upup.com
我把dns server和mail sever放一起都是192.168.91.3

4.比如192.168.91.4想给nagios@upup.com发邮件需要使用这个dns server,/etc/resolve.conf
测试下dns看host upup.com
echo "this this mail body"|mail -s subject1 nagios@upup.com

注意:lib64
vim /usr/lib64/sasl2/smtpd.conf 
