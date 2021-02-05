terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {
    subscription_id = "b9b38da4-8212-4863-985c-15886d9e8af0"
    client_id       = "0b1450b4-51ab-4d3e-a632-9ef59a0b5d61"
    client_secret   = qXCnjYwIaWq9dYOrhJED2fCtfL~c34x7vh
    tenant_id       = "79845616-9df0-43e0-8842-e300feb2642a"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "myTFRG"
  location = "westus2"
}