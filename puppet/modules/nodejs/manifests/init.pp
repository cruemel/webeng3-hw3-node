class nodejs {

	include apt
	include apt::backports

	apt::source { 'debian_backports':
        location => 'http://ftp.lt.debian.org/debian',
        release => 'wheezy-backports',
        repos => 'main',
        include_src => false,
    }

	package {
		"nodejs": ensure => "latest",
		 require => Apt::Source['debian_backports']
	}

	file { '/usr/bin/node':
  		ensure => 'link',
  		target => "/usr/bin/nodejs",
	}

	package {
		"curl": ensure => "latest"
	}

	exec { "npminstall":
		path => "/usr/bin",
  		command => "curl https://www.npmjs.org/install.sh | sudo sh",
  		require => Package["nodejs"]
	}

	# fix app
	file { "/vagrant/thmcards/app.js":
		ensure => 'link',
   	target => "/etc/puppet/files/thmcards/app.js"
	}

}
