class tests {

	class { 'sonarqube': }

	class { "jenkins":
      config_hash => {
        "HTTP_PORT" => { "value" => "9090" },
        "AJP_PORT" => { "value" => "9009" }
      },
      plugin_hash => {
      	"disk-usage" => {},
      	"log-parser" => {},
      	"dashboard-view" => {},
        	"git" => {},
        	"git-client" => {},
      	 "jquery" => {},
			"build-pipeline-plugin" => {},
        "performance" => {},
        "selenium-builder" => {},
        "sonar" => {},
        "deploy" => {}
      }
    }

    package { "jmeter":
  		ensure => "latest",
  		require => Package["java"]
  	}

	if !defined(Package['unzip']) {
    package {'unzip':
      ensure => installed
    }
  }

  	$version = "1.1.3"
  	$plugin = "JMeterPlugins-Standard"
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
    source => "http://jmeter-plugins.org/downloads/file/${plugin}-${version}.zip",
    destination => "${jmeter_dir}/${plugin}-${version}.zip",
    #notify => Exec["install-plugins"]
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
  		command => "sudo unzip -q -o ${plugin}-${version}.zip",
		path => "/usr/bin",
  		require => File["plugin-dir"]
  }

}
