class hockeykit {
	package { "libapache2-mod-php5": ensure => installed }
	package { 'git-core': ensure => installed, require => Package['libapache2-mod-php5'] }

	file { '/root/.ssh/config':
		ensure => present,
		source => "puppet:///modules/hockeykit/sshconfig",
		require => Package['git-core'],
		notify => Exec['fetch-hockeykit']
	}

	exec { "fetch-hockeykit":
		command => "/usr/bin/git clone https://github.com/TheRealKerni/HockeyKit.git /var/www/hockeykit",
		refreshonly => true
	} 

	file { "/etc/apache2/sites-enabled/000-default":
		ensure => present,
		source => "puppet:///modules/hockeykit/site",
		require => Exec['fetch-hockeykit'],
		notify => Service['apache2']
	}

	service { "apache2":
		hasrestart => true,
	}

}
