terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = "5b02f75508805bc32565c78a0e5a6ba775b6138dc47bcd5b664ea74cc68a67b4"
}
