class nodejs {

	include git

  	package { "build-essential": ensure => "latest" }

  	$node_version = "0.10.24"
  	$node_url = "https://github.com/joyent/node.git"
  	$node_path = "puppet/files/"

  git::repo { "nodejs":
    path => $node_path,
    source => $node_url,
    owner => "vagrant",
    group => "vagrant"
  }

  exec { "build node":
    cwd => "$node_path/node" ,
    command => "git checkout v$node_version \
        && ./configure \
        && make \
        && make install",
    require => [ Package["g++"], File["/usr/bin"] ],
    user => "root",
    timeout => "0"
  }

}
