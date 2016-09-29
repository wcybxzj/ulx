class apache::web inherits apache {
	file{'web.conf':
		ensure => file,
		source => 'puppet:///modules/apache/web.conf',
		path => '/etc/httpd/conf.d/web.conf',
		require => Package['httpd'],
		}
	file{'webpage':
		ensure => directory,
		source => 'puppet:///modules/apache/sohu',
		path => '/srv/sohu',
		recurse => true,
		mode => '0755',
		}
	service{"httpd":
		ensure => true,
		subscribe => File['httpd.conf','web.conf'],
	}
}
