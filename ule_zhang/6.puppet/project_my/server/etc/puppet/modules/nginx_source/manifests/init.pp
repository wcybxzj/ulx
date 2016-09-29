class nginx_source{
	file {'nginx':
		source => "puppet:///modules/nginx_source/nginx.tar.gz",
		path => '/tmp/nginx.tar.gz',
		}
	exec {'nginx':
		command => 'tar -xvf /tmp/nginx.tar.gz -C /usr/local/',
		path => '/bin:/sbin:/usr/bin:/usr/sbin',
		require => File['nginx'],
		} ->
	user {'nginx':
		ensure => present,
		} ->
	exec {'nginxmode':
		command => 'chown -R nginx.nginx /usr/local/nginx',
                path => '/bin:/sbin:/usr/bin:/usr/sbin',
		}
}
