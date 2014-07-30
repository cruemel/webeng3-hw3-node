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
      	 "jquery" => {},
			"build-pipeline-plugin" => {},
        "performance" => {},
        "sonar" => {},
        "deploy" => {},
      }
    }

}
