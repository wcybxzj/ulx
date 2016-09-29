class apache{
	package {"httpd":
		ensure => present,
		}
}
class apache::web inherits apache {
	file {'/etc/httpd/conf/httpd.conf':
		ensure => file,
		source => '/tmp/apache/httpd.web.conf',
		require => Package['httpd'],
		notify => Service['httpd'],
	}
	service{"httpd":
		ensure => true,
	}
}
class apache::virtual inherits apache {
	file {'/etc/httpd/conf/httpd.conf':
		ensure => file,
		source => '/tmp/apache/httpd.virtual.conf',
		require => Package['httpd'],
		notify => Service['httpd'],
	}
	service{"httpd":
		ensure => true,
	}
} 

