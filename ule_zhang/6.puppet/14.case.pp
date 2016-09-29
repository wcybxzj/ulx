 case $operatingsystem {
        /^(?i-mx:redhat|centos|fedora)/:{
        package{'httpd':
                ensure => present,
                provider => yum,
                }
        }
        /^(?i-mx:ubuntu|debian)/:{
        package{'apache2':
                ensure => present,
                provider => apt
                }
        }
        default:{
        notify{'notice':
                messages => 'unkown system',
                }
        }
}    
