##################################################
# Attached Public IP to NIC (ip_configuration block)
##################################################

resource "azurerm_network_interface" "example" {
  name                = "aap-vm-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal-ip"
    subnet_id                     = azurerm_subnet.app-subnet["AppSubnet"].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "app_vm" {

  name = "appvm"

  resource_group_name = azurerm_resource_group.example.name
  location            = var.location

  size                = var.vm_size
  admin_username      = var.username
  admin_password      = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id
  ]

  source_image_reference {
    publisher = "Debian"
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.os_disk_size
  }

  # #######################
  # Add cloud-init commands
  # #######################
custom_data = base64encode(<<EOF
#cloud-config
runcmd:
  - iptables -C INPUT -p tcp --dport 80 -j ACCEPT || iptables -I INPUT -p tcp --dport 80 -j ACCEPT
  - apt-get update -y
  - apt-get install -y iptables-persistent nginx
  - systemctl enable nginx
  - systemctl start nginx
  - netfilter-persistent save
EOF
)
  tags = var.tags
}
