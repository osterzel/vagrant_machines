class redis-commander {

  package { "software-properties-common": ensure => installed }

  exec { 'add-chris-lea-nodejs':
	command => 'add-apt-repository ppa:chris-lea/node.js',
	require => Package['software-properties-common'],
        notify => Exec['re-aptupdate']
  }

  exec { 're-aptupdate':
    command => '/usr/bin/apt-get update',
    refreshonly => true
  }

  package { "nodejs": ensure => installed, require => Exec['re-aptupdate'] }
  package { "git-core": ensure => installed, require => Package['nodejs'] }

  file { "/root/.ssh/config":
	ensure => present,
	source => "puppet:///modules/redis-commander/sshconfig",
	require => Package['nodejs'],
	notify => Exec['fetch-redis-commander']
  }

  exec { 'fetch-redis-commander':
	command => '/usr/bin/git clone https://github.com/joeferner/redis-commander.git /var/tmp/redis-commander',
	refreshonly => true,
	notify => Exec['install-redis-commander']
  }

  exec { 'install-redis-commander':
	command => 'npm install -g /var/tmp/redis-commander',
	refreshonly => true
  } 

  file { '/etc/init/redis-commander.conf':
	ensure => present,
	source => "puppet:///modules/redis-commander/redis-command-init",
	require => Exec['install-redis-commander'],
  }

  file { '/etc/init.d/redis-commander':
	ensure => link,
	target => '/lib/init/upstart-job',
	require => File['/etc/init/redis-commander.conf'],
	notify => Service['redis-commander']
  }

  service { "redis-commander":
	hasrestart => true,
	ensure => running,
	require => File['/etc/init.d/redis-commander']
  }


}
