class app {

	include git
	include nodejs

	file { "/vagrant/thmcards":
    	ensure => "directory",
  	}

	git::repo { "thmcards":
 		target => "/vagrant/thmcards/src",
		source => 'https://github.com/cruemel/thmcards.git',
		user => 'vagrant',
		require => File["/vagrant/thmcards"]
  }

  	exec { "create-couchviews":
  		cwd => "/vagrant/thmcards/src",
		command => "python createviews.py",
		path => "/usr/bin",
		require => [ Package["python"] ],
		user => "vagrant"
	}

	file { "/usr/local/bin/npm":
  		ensure => link,
  		target => "/usr/local/node/node-default/bin/npm",
  		require => Nodejs::Install["nodejs-stable"]
	}

	exec { "install-npm":
  		cwd => "/vagrant/thmcards/src",
		command => "npm install",
		path => "/usr/local/bin",
		require => File["/usr/local/bin/npm"],
		user => "vagrant"
	}

  # file { "/home/vagrant/start.sh":
  #  owner => "vagrant",
  #  group => "vagrant",
  #  content => template("app/start.sh.erb"),
  #  mode => "744"
  #}

  class { "motd":
    template => "app/motd.erb"
  }

}
