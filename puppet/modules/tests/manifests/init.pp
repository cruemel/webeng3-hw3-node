class tests {

  $base_path = "/vagrant"
  $server_path = "$base_path/arsnova-war"
  $mobile_path = "$base_path/arsnova-mobile"
  $server_pid = "server.pid"
  $mobile_pid = "mobile.pid"
  $listen_pid = "listen.pid"

  package { "maven": ensure => "latest" }
  package { "couchdb": ensure => "latest" }
  package { "ant": ensure => "latest" }
  package { "ruby-dev": ensure => "latest" }
  package { "listen": ensure => "latest", provider => "gem" }

	class { 'sonarqube': }

   class { "jenkins":
      config_hash => {
        "HTTP_PORT" => { "value" => "9090" },
        "AJP_PORT" => { "value" => "9009" }
      },
      plugin_hash => {
        "git-client" => {},
        "scm-api" => {},
        "git" => {},
        "clone-workspace-scm" => {},
        "deploy" => {},
        "disk-usage" => {},
        "build-blocker-plugin" => {},
        "log-parser" => {},
        "sonar" => {},
        "dashboard-view" => {},
        "jquery" => {},
        "parameterized-trigger" => {},
        "build-pipeline-plugin" => {}
      }
    }

    jenkins::job { "arsnova-jenkins-job-mobile":
      name => "ARSnova-mobile",
      config_file => "/etc/puppet/files/jenkins/arsnova-mobile.config.xml"
    }

    jenkins::job { "arsnova-jenkins-job-war":
      name => "ARSnova-war",
      config_file => "/etc/puppet/files/jenkins/arsnova-war.config.xml"
    }

    jenkins::job { "arsnova-jenkins-job-deploy":
      name => "ARSnova.deploy",
      config_file => "/etc/puppet/files/jenkins/arsnova-deploy.config.xml"
    }

    jenkins::job { "arsnova-jenkins-job-arsnova-war-sonar":
      name => "ARSnova-war.sonar",
      config_file => "/etc/puppet/files/jenkins/arsnova-war-sonar.config.xml"
    }

    # Jenkins might be installed to different paths depending on OS
    $jenkins_home = $::osfamily ? {
      "Debian" => "/var/lib/jenkins",
      default => fail("Unsupported OS family: ${::osfamily}")
    }

    file { "${jenkins_home}/hudson.tasks.Maven.xml":
      require => Class["jenkins::package"],
      source => "/etc/puppet/files/jenkins/hudson.tasks.Maven.xml",
      notify => Service["jenkins"]
    }

    file { "${jenkins_home}/hudson.plugins.sonar.SonarPublisher.xml":
      require => Class["jenkins::package"],
      source => "/etc/puppet/files/jenkins/hudson.plugins.sonar.SonarPublisher.xml",
      notify => Service["jenkins"]
    }

    file { ["${jenkins_home}/.sencha", "${jenkins_home}/.sencha/cmd"]:
      ensure => "directory",
      require => [Group["jenkins"], User["jenkins"]]
    }
    ->
    file { "${jenkins_home}/.sencha/cmd/sencha.cfg":
      content => 'repo.local.dir=${home.dir}/../repo',
    }
    ->
    exec { "jenkins-sencha-permissions":
      command => "/bin/chown -R jenkins:jenkins ${jenkins_home}/.sencha"
    }

  }
}
