terraform {
  required_version = ">= 1.8.2"
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}
