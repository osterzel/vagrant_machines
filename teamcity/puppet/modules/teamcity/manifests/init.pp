class teamcity {
	package { 'openjdk-6-jre': ensure => installed }


	#Fetch teamcity zip
	exec { 'fetch-teamcity':
		command => 'wget http://download-cf.jetbrains.com/teamcity/TeamCity-8.1.2.tar.gz',
		refreshonly => true
	}
}
