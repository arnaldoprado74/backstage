terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.18.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.96.0"
    }
    template = {
      source = "hashicorp/template"
    }
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
    tls = {
      source = "hashicorp/tls"
    }
    acme = {
      source = "registry.terraform.io/vancluever/acme"
      version = "2.8.0"
    }
  }
  required_version = ">= 0.13"
}
