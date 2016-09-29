class httpd{
	yumrepo { "Server":
		descr   => "Server repo",
		baseurl => "ftp://192.168.91.3/pub/mnt",
		gpgcheck => "0",
		enabled  => "1";         				
		}

	package { "httpd":
		ensure => installed,
		require => Yumrepo["Server"];
		}
}
