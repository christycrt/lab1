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

resource "azurerm_virtual_network" "example" {
  name                = "INT493-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "example" {
    name                = "myNetworkSecurityGroup"
    location            = var.location
    resource_group_name = var.resource_group_name

    security_rule {
        name                       = "Port_8080"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "8080"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "example" {
  name                = "INT493-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.example.id
    network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "INT493-machine"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "CRT200858christy"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  connection {
    host = self.public_ip
    user = self.admin_username
    password = self.admin_password
  }

  provisioner "remote-exec" {
   inline = [
       "sudo apt-get update",
       "sudo apt install go -y",
       "sudo apt install git -y",
       "git clone https://github.com/christycrt/lab1",
       "cd lab1",
       "go build .",
       "sudo mv lab1.service /etc/systemd/system/",
       "sudo systemctl enable lab1.service",
       "sudo systemctl start lab1.service"
   ]
  }
}