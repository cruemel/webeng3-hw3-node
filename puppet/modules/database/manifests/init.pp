class database {

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

}
