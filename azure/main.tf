# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "random_pet" "group_name" {
  prefix = "instance"

  length = 2
}

resource "azurerm_resource_group" "instance" {
  name     = "instance-${random_pet.group_name.id}"
  location = var.region
}

resource "tls_private_key" "instance" {
  algorithm = "ED25519"
}

resource "azurerm_virtual_network" "instance" {
  name                = var.vnet_name
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.instance.location
  resource_group_name = azurerm_resource_group.instance.name
}

resource "azurerm_subnet" "public" {
  count = length(var.public_subnets)

  name                 = "public-subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.instance.name
  virtual_network_name = azurerm_virtual_network.instance.name
  address_prefixes     = [var.public_subnets[count.index]]
}

resource "azurerm_subnet" "private" {
  count = length(var.private_subnets)

  name                 = "private-subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.instance.name
  virtual_network_name = azurerm_virtual_network.instance.name
  address_prefixes     = [var.private_subnets[count.index]]
}

resource "azurerm_network_security_group" "allow_ssh" {
  name                = "allow_ssh"
  location            = azurerm_resource_group.instance.location
  resource_group_name = azurerm_resource_group.instance.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "public" {
  count = length(var.public_subnets)

  subnet_id                 = azurerm_subnet.public[count.index].id
  network_security_group_id = azurerm_network_security_group.allow_ssh.id
}

resource "azurerm_network_interface" "private" {
  count               = length(azurerm_subnet.private.*.id) * var.instances_per_subnet
  name                = "nic-${count.index}"
  location            = azurerm_resource_group.instance.location
  resource_group_name = azurerm_resource_group.instance.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private.*.id[count.index % length(azurerm_subnet.private.*.id)]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "private" {
  count                     = length(azurerm_subnet.private.*.id) * var.instances_per_subnet
  network_interface_id      = azurerm_network_interface.private[count.index].id
  network_security_group_id = azurerm_network_security_group.allow_ssh.id
}

resource "azurerm_linux_virtual_machine" "private" {
  count               = length(azurerm_subnet.private.*.id) * var.instances_per_subnet
  name                = "vm-${count.index}"
  size                = var.instance_type
  admin_username      = "ubuntu"
  location            = azurerm_resource_group.instance.location
  resource_group_name = azurerm_resource_group.instance.name

  network_interface_ids = [
    azurerm_network_interface.private[count.index].id
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = tls_private_key.instance.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
