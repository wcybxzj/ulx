package {'apache':
	ensure => present,
	name=>httpd
}
service {'httpd':
    ensure => true,
    enable => true,
    require => Package['apache'],
}
