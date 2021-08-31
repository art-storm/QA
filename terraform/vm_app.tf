# VM for app
resource "azurerm_network_interface" "app" {
  name                = "${var.prefix}-nic-app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig-app"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app.id
  }
}

resource "azurerm_public_ip" "app" {
  name                = "${var.prefix}-publicIp-app"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "testing"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "app" {
    network_interface_id      = azurerm_network_interface.app.id
    network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_virtual_machine" "app" {
  name                  = "${var.prefix}-vm-app"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.app.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-debian-osdisk-app"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-app"
    admin_username = var.admin_user
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("d:/Programs/ssh-keys/azure-weu-key.pub")
      path = "/home/${var.admin_user}/.ssh/authorized_keys"
    }
  }

  tags = {
    environment = "testing"
  }
}
