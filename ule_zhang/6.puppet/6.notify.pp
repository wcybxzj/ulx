file {'/tmp/test.txt':
	ensure => file,
	content => "nnnnnnnnnnnnnnnnnnn",
	notify => Exec['monitor'],
}

exec {'monitor':
	path => '/bin:/sbin:/usr/bin:/usr/sbin',
	command => 'echo "/tmp/test.txt change" >> /tmp/monitor.txt',
	refreshonly => true,
}
