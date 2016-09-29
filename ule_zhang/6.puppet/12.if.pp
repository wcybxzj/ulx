if $operatingsystem == 'Redhat' {
        notify {'redhat':
	message => "Welcome to $operatingsystem linux server",}
}        
elsif $operatingsystem == 'CentOS' {
        notify {'centos':
	message => "Welcome to $operatingsystem linux server",}
}
elsif $operatingsystem == 'Fedora' {
        notify {'fedora':
	message => "Welcome to $operatingsystem	 linux server",}
}
else {
	notify {'fedora':
	message => "Unknow system",}
}
