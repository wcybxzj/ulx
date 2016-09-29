$webserver = $operatingsystem ? {
        /^(?i-mx:redhat|centos|fedora)/ => 'httpd',
        /^(?i-mx:ubuntu|debian)/        => 'apache2',
}

class httpd($pkgname = 'apache2') {
        package {"$pkgname":
                ensure => present,
                }
        service {"$pkgname":
                ensure => true,
                require => Package["$pkgname"],
                }
        }
class {'httpd':
        pkgname => $webserver,
}
