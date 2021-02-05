terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "b9b38da4-8212-4863-985c-15886d9e8af0"
  client_id       = "0b1450b4-51ab-4d3e-a632-9ef59a0b5d61"
  client_secret   = var.CLIENT_SECRET
  tenant_id       = "79845616-9df0-43e0-8842-e300feb2642a"
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "INT493-machine"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "CRT200858christy"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}