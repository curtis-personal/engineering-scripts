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
    use_cli = false
    subscription_id                 = "00000000-0000-0000-0000-000000000000"
    resource_provider_registrations = "none"
}

data "azurerm_network_service_tags" "aad" {
  location        = "uksouth"
  service         = "AzureActiveDirectory"
}