file {'/etc/issue.test':
	ensure => file,
	content => $operatingsystem,
}
