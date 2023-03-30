data "harness_platform_organization" "default" {
  identifier = "default"
}

data "harness_platform_project" "Default_Project_1659484619331" {
  name   = "Default Project"
  org_id = data.harness_platform_organization.default.id
}

resource "harness_platform_connector_kubernetes" "orka" {
  identifier = "orka"
  name       = "orka"

  inherit_from_delegate {
    delegate_selectors = ["orka"]
  }
}

resource "harness_platform_connector_kubernetes" "zira" {
  identifier = "zira"
  name       = "zira"

  inherit_from_delegate {
    delegate_selectors = ["zira"]
  }
}

resource "harness_platform_connector_github" "rssnyder" {
  identifier = "rssnyder"
  name       = "rssnyder"

  url             = "https://github.com/rssnyder"
  connection_type = "Account"
  validation_repo = "test"
  credentials {
    http {
      username  = "rssnyder"
      token_ref = "account.rssnyder_pat"
    }
  }

  api_authentication {
    token_ref = "account.rssnyder_pat"
  }
}

resource "harness_platform_connector_docker" "dockerhub" {
  identifier = "dockerhub"
  name       = "dockerhub"

  type = "DockerHub"
  url  = "https://index.docker.io/v2/"
  credentials {
    username     = "rssnyder"
    password_ref = "account.dockerhub_token"
  }
}

resource "harness_platform_connector_docker" "ghcr" {
  identifier = "ghcr"
  name       = "ghcr"

  type = "Other"
  url  = "https://ghcr.io/"
  credentials {
    username     = "rssnyder"
    password_ref = "account.rssnyder_pat"
  }
}

resource "harness_platform_connector_docker" "hurley" {
  identifier = "hurley"
  name       = "hurley"

  type = "Other"
  url  = "https://registry.rileysnyder.dev/"
  credentials {
    username     = "rssnyder"
    password_ref = "account.hurley_pat"
  }
}

resource "harness_platform_connector_helm" "blakeblackshear" {
  identifier = "blakeblackshear"
  name       = "blakeblackshear"

  url = "https://blakeblackshear.github.io/blakeshome-charts/"
}