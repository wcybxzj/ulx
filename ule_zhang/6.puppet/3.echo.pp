exec {'echo cmd':
	command => 'echo "hello world" > /dev/pts/2',
	path => '/bin:/sbin:/usr/bin:/usr/sbin',
}
