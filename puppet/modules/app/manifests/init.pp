class app {

	include git
	include nodejs

	git::repo { "thmcards":
 		target => "/vagrant/thmcards",
		source => 'https://github.com/cruemel/thmcards.git',
		user => 'vagrant',
  }

  	exec { "create-couchviews":
  		cwd => "/vagrant/thmcards",
		command => "python createviews.py",
		path => "/usr/bin",
		require => [ Package["python"], Git::Repo["thmcards"] ],
		user => "vagrant"
	}

	file { "/usr/local/bin/node":
  		ensure => link,
  		target => "/usr/local/node/node-default/bin/node",
  		require => Nodejs::Install["nodejs-stable"]
	}

	file { "/usr/local/bin/npm":
  		ensure => link,
  		target => "/usr/local/node/node-default/bin/npm",
  		require => Nodejs::Install["nodejs-stable"]
	}

	exec { "install-npm":
  		cwd => "/vagrant/thmcards",
		command => "npm install",
		path => "/usr/local/bin",
		require => Nodejs::Install["nodejs-stable"],
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
