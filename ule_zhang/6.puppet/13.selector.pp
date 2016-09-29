$webserver = $operatingsystem ? {
        /^(?i-mx:ubuntu|debian)/ => 'apache2',
        /^(?i-mx:fedora|redhat|centos)/ => 'httpd',
}
notify {'kokok':
	message => "Welcome to $webserver linux server",
}
package {"$webserver":
        ensure => present,
        provider => $webprovider,
}     

