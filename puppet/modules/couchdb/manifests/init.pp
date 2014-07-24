class couchdb {

	include git

	$base = "/vagrant"
	$repo = "https://github.com/thmcards/thmcards.git"

	package {"python":
    	ensure => present,
	}

  	package { "couchdb":
  		ensure => "latest"
  	}

  	package { "python-couchdb":
  		ensure => "latest"
  	}

  service { "couchdb":
    ensure => "running",
    enable => true,
    require => Package["couchdb"]
  }

   conf { "couchdb-ini":
    notify => Service["couchdb"],
  }

	git::repo { "thmcards":
 		target => "/vagrant/thmcards",
		source => 'https://github.com/thmcards/thmcards.git',
		user => 'user',
  }

	# fix couchviews
	file { "/vagrant/thmcards/couchviews/default_bagdges.design":
		ensure => 'link',
   	source => "/etc/puppet/files/thmcards/couchviews/default_bagdges.design",
	}

  exec { "create-couchviews":
		command => "python /vagrant/thmcards/createviews.py",
		path => "/usr/bin/:/usr/local/bin/",
		require => [ Package["python"] ],
		user => "vagrant"
	}

}
