file {'/tmp/test.txt':
	ensure => file,
	content => "hello world"
}

exec {'monitor':
	path => '/bin:/sbin:/usr/bin:/usr/sbin',
	command => 'echo "/tmp/test.txt change" >> /tmp/monitor.txt',
	refreshonly => true,
	subscribe => File['/tmp/test.txt'], 
}
