class nginx {
yumrepo { "nginx":
	descr	=> "nginx",
	baseurl => "ftp://192.168.91.3/pub/nginx",
	gpgcheck => "0",
	enabled => "1";
	}->
package { "nginx": 
	provider => "yum",
	ensure	=> latest;
	}->
file { "nginx.conf": 
	ensure	=> present,
	mode	=> 644,
	owner	=> root,
	group	=> root,
	path	=> "/etc/nginx/nginx.conf",
	content	=> template("nginx/nginx.conf"),
	} ~>
service { "nginx":
	ensure	=> running,
	enable	=> true,
	hasrestart => true,
	hasstatus  => true,
	}
}   
