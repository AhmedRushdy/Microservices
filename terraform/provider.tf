terraform {

    required_providers {
        azapi = {
            source  = "azure/azapi"
            version = "~>1.5"
        }
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~>3.0"
        }
        random = {
            source  = "hashicorp/random"
            version = "~>3.0"
        }
        time = {
            source  = "hashicorp/time"
            version = "0.9.1"
        }


  }
  backend "azurerm" {
    resource_group_name  = "pwc-task"
    storage_account_name = "terraformstate1759533356"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
