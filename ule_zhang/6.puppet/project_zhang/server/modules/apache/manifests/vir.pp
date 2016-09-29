class apache::vir inherits apache {
        file{'vir.conf':
                ensure => file,
                source => 'puppet:///modules/apache/vir.conf',
		path => '/etc/httpd/conf.d/vir.conf',
                require => Package['httpd'],
                }
	file{'webpage':
	        ensure => directory,
       		source => 'puppet:///modules/apache/sina',
        	path => '/srv/sina',
        	recurse => true,
       		mode => '0755',
        }
        service{"httpd":
                ensure => true,
		subscribe => File['httpd.conf','vir.conf'],
        }       
}       
