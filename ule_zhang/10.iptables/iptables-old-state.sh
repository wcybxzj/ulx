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
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -m state --state ESTABLISHED -j ACCEPT

################ HTTPD #######################
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -m state --state ESTABLISHED -j ACCEPT

################ VNC ########################
iptables -A INPUT -p tcp --dport 5900 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --sport 5900 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 5900 -m state --state ESTABLISHED -j ACCEPT

############### FTP #########################
###### port ######
iptables -A INPUT -p tcp --dport 21 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --sport 21 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 20 -m state --state RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 20 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 20 -m state --state ESTABLISHED -j ACCEPT
##### pasv ######
iptables -A INPUT -p tcp --dport 21 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --sport 21 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -m state --state RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
