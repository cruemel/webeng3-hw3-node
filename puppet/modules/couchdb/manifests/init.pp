class couchdb {

	include git

	$project_path = "/vagrant/thmcards"

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

#git::repo { "thmcards":
 # 		path => $project_path,
  #		source => "https://github.com/thmcards/thmcards.git",
  	#	owner => "vagrant",
  	#	group => "vagrant"
  #}

  #	exec { "initialize-couchdb":
  #	cwd => $project_path,
	#	command => "python createviews.py",
   #	require => [ Package["python"], Git::Repo["thmcards"] ],
   #	user => "vagrant"
  #}

}
