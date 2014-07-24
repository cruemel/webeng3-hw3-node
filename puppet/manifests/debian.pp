
# Ensure the repository is updated before any package is installed
exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

# Exec["apt-update"] -> Package <| |>

# Use Mac style installation folder
file { "/usr/local/bin":
  owner => "vagrant",
  group => "vagrant",
  recurse => true
}

# bash is not the default...
user { "vagrant":
  ensure => present,
  shell  => "/bin/bash"
}

include couchdb
include nodejs
