class subversion {

	package { "subversion": ensure => installed, require => Package['libapache2-svn'] }
	package { "apache2": ensure => installed }
	package { "libapache2-svn": ensure => installed, require => Package['apache2'] }

	file { "/srv/svn":
		ensure => directory,
		require => Package['subversion'],
		notify => Exec['make-test-project'],
	}

	exec { "make-test-project":
		command => "svnadmin create /srv/svn/testproject",
		refreshonly => true,
		notify => Exec['setup-folder-ownership']
	}

	exec { "setup-folder-ownership":
		command => "chown -R www-data:subversion /srv/svn/testproject",
		refreshonly => true,
		notify => Exec['setup-folder-permissions'],
	}

	exec { "setup-folder-permissions":
		command => "chmod -R g+rws /srv/svn/testproject",
		refreshonly => true,
		notify => Exec['enable-webdav'],
	}

	exec { "enable-webdav":
		command => "a2enmod dav",
		refreshonly => true,
	}

	file { "/etc/apache2/mods-enabled/dav_svn.conf":
		ensure => present,
		source => "puppet:///modules/subversion/dav_svn.conf",
		require => Exec['enable-webdav'],
	}

	file { "/etc/subversion/passwd":
		ensure => present,
		source => "puppet:///modules/subversion/passwdfile",
		require => File['/etc/apache2/mods-enabled/dav_svn.conf'],
		notify => Service['apache2']
	} 

	service { "apache2":
		hasrestart => true,
		ensure => running,
		require => Package['apache2']
	}


}
