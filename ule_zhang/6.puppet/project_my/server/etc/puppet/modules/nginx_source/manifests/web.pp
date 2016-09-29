class nginx_source::web inherits nginx_source {
case $hostname {
	/^(?i-mx:agent1*)/:{
		file {'nginx.conf':
			ensure => file,
			content => template('nginx_source/nginx.web.conf'),
			path => '/usr/local/nginx/conf/nginx.conf',
			} ->
		exec {'nginxstop':
			command => 'killall nginx',
			path => '/usr/local/nginx/sbin/:/usr/bin/',
			} ->
		exec {'nginxstart':
			command => 'nginx',
			path => '/usr/local/nginx/sbin/',
			}			
		}
	/^(?i-mx:agent2*)/:{
		file {'nginx.conf':
			ensure => file,
			content => template('nginx_sopurce/nginx.proxy.conf'),
			path => '/usr/local/nginx/conf/nginx.conf',
			} ->
		exec {'nginxstop':
			command => 'killall nginx',
			path => '/usr/local/nginx/sbin/:/usr/bin/',
			} ->
		exec {'nginxstart':
			command => 'nginx',
			path => '/usr/local/nginx/sbin/',
			}			
		}
	
	default:{
		notify {'notice':
			message => "no server",
		}
	}
   }	
}
