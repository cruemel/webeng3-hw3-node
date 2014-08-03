class tests {

	class { "sonarqube": }

	if !defined(Package['unzip']) {
    package {'unzip':
      ensure => installed
    }
  }

  $runner_version = "2.4"
  $runner_url = "http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist"
  $share_dir = "/usr/share"
	$runner_home = "${share_dir}/sonar-runner-${runner_version}/bin"

	wget::fetch { "download-sonar-runner":
    source => "${runner_url}/${runner_version}/sonar-runner-dist-${runner_version}.zip",
    destination => "${share_dir}/sonar-runner-dist-${runner_version}.zip",
    require => Package["java"]
  }

   exec { 'install-sonar-runner':
  		cwd => "/usr/share",
  		command => "sudo unzip -q -o sonar-runner-dist-${runner_version}.zip",
		path => "/usr/bin",
  		require => Wget::Fetch["download-sonar-runner"]
  }

   file { "/etc/environment":
      content => inline_template("SONAR_RUNNER_HOME=${runner_home}")
   }

	class { "jenkins":
      config_hash => {
        "HTTP_PORT" => { "value" => "9090" },
        "AJP_PORT" => { "value" => "9009" }
      },
      plugin_hash => {
      	"ansicolor" => {},
      	"disk-usage" => {},
      	"dashboard-view" => {},
      	"log-parser" => {},
        	"git" => {},
        	"git-client" => {},
        	"scm-api" => {},
        	 "clone-workspace-scm" => {},
      	 "jquery" => {},
      	  "build-blocker-plugin" => {},
			"build-pipeline-plugin" => {},
			"parameterized-trigger" => {},
        "performance" => {},
        "sauce-ondemand" => {},
        "selenium-builder" => {},
        "sonar" => {},
        "deploy" => {}
      }
    }

    package { "jmeter":
  		ensure => "latest",
  		require => Package["java"]
  	}

  	$plugin_version = "1.1.3"
  	$plugin_name = "JMeterPlugins-Standard"
  	$jmeter_dir = "/usr/share/jmeter"
  	$lib_dir = "${jmeter_dir}/lib"
  	$plugin_dir = "${lib_dir}/ext"

  	ensure_resource('file', 'install-dir', {
    ensure => 'directory',
    path   => $jmeter_dir,
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
  })

wget::fetch { "download-plugins":
    source => "http://jmeter-plugins.org/downloads/file/${plugin_name}-${plugin_version}.zip",
    destination => "${jmeter_dir}/${plugin_name}-${plugin_version}.zip",
    notify => Exec["install-plugins"]
  }

  ensure_resource('file', 'lib-dir', {
    ensure  => 'directory',
	path   => $lib_dir,
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  })

  	ensure_resource('file', 'plugin-dir', {
    ensure  => 'directory',
	path   => $plugin_dir,
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  })

   exec { 'install-plugins':
  		cwd => $jmeter_dir,
  		command => "sudo unzip -q -o ${plugin_name}-${plugin_version}.zip",
		path => "/usr/bin",
  		require => File["plugin-dir"]
  }

	jenkins::job { "selenium-test":
     name => "acceptance-test",
     config_file => "/etc/puppet/files/selenium/jobs/config.xml"
   }

   jenkins::job { "jmeter-test":
     name => "load-test",
     config_file => "/etc/puppet/files/jmeter/jobs/config.xml"
   }

   jenkins::job { "sonar-analyse":
     name => "code-analyse",
     config_file => "/etc/puppet/files/sonar/jobs/config.xml"
   }

   jenkins::job { "cloudcontrol-deploy":
     name => "deploy-pass",
     config_file => "/etc/puppet/files/cloudcontrol/jobs/config.xml"
   }

    # Jenkins might be installed to different paths depending on OS
    $jenkins_home = $::osfamily ? {
      "Debian" => "/var/lib/jenkins",
      default => fail("Unsupported OS family: ${::osfamily}")
    }


}
