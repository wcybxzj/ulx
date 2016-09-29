case $operatingsystem {
	'Redhat': {notice("Redhat")}
	'CentOS','Windos': {notice("CentOS")}
	/^(Fedora|Debian)$/: {notice("$1")}
	defualt: {notice("no one")}
}
