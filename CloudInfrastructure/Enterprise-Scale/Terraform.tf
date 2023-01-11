terraform {
  required_version = "~> 1.3.0"
  required_providers{
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.8.0"
    }
  }

  backend "azurerm"{
    subscription_id = "e0708d2e-eab2-461f-9792-16a0a36a5a86"
    storage_account_name = "ioa1"
    container_name = "tfstate-enterprisescale-test"
  }

  provider "azurerm"{
    subscription_id = var.subscription_id
    features {}
  }
}