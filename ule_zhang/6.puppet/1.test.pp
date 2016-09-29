package {'apache':
        ensure => present,
        name => httpd,
}             
service {'httpd':
        ensure => true,
        name => httpd,
        enable => true,
}
