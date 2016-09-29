class apache {
	package{'apache':
		ensure => present,
		name => httpd,
	}->
	file{'httpd.conf':
		ensure => file,
		content => template('apache/httpd.conf.erb'),
		path => '/etc/httpd/conf/httpd.conf',
		mode => '0644',
	}
}
