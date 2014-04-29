class puppetmaster {

  exec { "fetch-puppetlabs-repo":
	command => "wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb",
	notify => Exec['install-apt-repo']
  }

  exec { "install-apt-repo":
	command => "dpkg -i puppetlabs-release-trusty.deb && apt-get update",
	refreshonly => true
  }

  package { "puppetmaster-passenger": ensure => installed, require => Exec['install-apt-repo'] }

}
