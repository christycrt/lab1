terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

backend "remote" {
    organization = "<ORG_NAME>"
    workspaces {
        name = "Example-Workspace"
    }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "myTFRG"
  location = "westus2"
}