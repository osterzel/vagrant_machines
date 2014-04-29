class python {
	package { 'ipython': ensure => installed }
	package { 'python-pip': ensure => installed }
	package { 'python-virtualenv': ensure => installed }
	package { 'python-requests': ensure => installed }
	package { 'python-twisted': ensure => installed }
	package { 'python-gevent': ensure => installed }
}
