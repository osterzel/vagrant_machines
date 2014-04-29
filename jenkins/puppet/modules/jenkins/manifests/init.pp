class jenkins {

	file { "/etc/apt/sources.list.d/jenkins.list":
		ensure => present,
		source => "puppet:///modules/jenkins/jenkins.list",
		notify => Exec['add-key']
	}

	exec { "add-key":
		command => "/usr/bin/wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -",
		refreshonly => true,
		notify => Exec["apt-update"]
	}

	exec { "apt-update":
		command => "/usr/bin/apt-get update",
		refreshonly => true
	}

	package { 'jenkins': ensure => installed, require => Exec['apt-update'] }
}
