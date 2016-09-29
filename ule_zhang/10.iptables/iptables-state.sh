#!/bin/bash
# flush iptables
iptables -F
# default rule 
iptables -P INPUT DROP
iptables -P OUTPUT DROP
# add conntrack module
modprobe nf_conntrack_ftp
# add lo network accept
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

################# SSHD #######################
################ HTTPD #######################
################ VNC ########################
############### FTP #########################
iptables -A INPUT -p tcp -m multiport --dport 20,21,22,80,5900 -m state --state NEW -j ACCEPT
###### port ######
iptables -A OUTPUT -p tcp --sport 20 -m state --state RELATED -j ACCEPT
##### pasv ######
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
