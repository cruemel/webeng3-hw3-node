class tests {

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

}
