class tests {

	package {"unzip":
    	ensure => present,
	}

	class { 'sonarqube':
		require => Package["unzip"]
	}

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

    class { 'jmeter':
    	require => Package["unzip"]
    }

}
