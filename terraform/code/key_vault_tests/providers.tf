terraform {
backend "local" {
    path = "./terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
    use_cli                         = true
    tenant_id                       = var.tenant_id
    subscription_id                 = var.subscription_id
    resource_provider_registrations = "none"
}