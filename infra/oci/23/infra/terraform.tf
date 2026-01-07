terraform {
  backend "s3" {
    bucket                      = "isengard"
    key                         = "oci/23/infra/terraform.tfstate"
    endpoint                    = "http://192.168.2.2:9000"
    region                      = "main"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }
  required_providers {
    jq = {
      source  = "massdriver-cloud/jq"
      version = "0.2.1"
    }
    oci = {
      source  = "oracle/oci"
      version = "~> 6.35.0"
    }
  }
}

provider "oci" {
}
