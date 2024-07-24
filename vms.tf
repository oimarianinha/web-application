# Create VMs

resource "azurerm_linux_virtual_machine" "vms" {
  count                 = var.qtdade_resources
  name                  = "acmeVM${count.index}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.acme-network-interface[count.index].id]
  size                  = "Standard_DS1_v2"
  os_disk {
    name                 = "acmeVM${count.index}OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  computer_name  = "vm${count.index}"
  disable_password_authentication = false
  admin_username = var.username
  admin_password = var.password

  depends_on = [ 
    azurerm_network_interface_security_group_association.net_nsg_acme
  ]
}

# Conecta NSG com as VMs
resource "azurerm_network_interface_security_group_association" "net_nsg_acme" {
  count                     = var.qtdade_resources
  network_interface_id      = azurerm_network_interface.acme-network-interface[count.index].id
  network_security_group_id = azurerm_network_security_group.acme-security-group.id
}


resource "local_file" "inventory" {
  content = templatefile("inventory.tpl", {
    web_ip       = azurerm_public_ip.acme-public-ip[0].ip_address,
    web_user     = var.username
    web_password = var.password
  })
  filename = "./ansible/inventory.ini"
}


resource "null_resource" "run_ansible_playbook" {

  count = length(azurerm_linux_virtual_machine.vms)

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

    connection {
      host        = azurerm_linux_virtual_machine.vms[count.index].public_ip_address
      type        = "ssh"
      user        = var.username
      password    = var.password
    }
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --username ${var.username} --host '${azurerm_linux_virtual_machine.vms[count.index].public_ip_address},' --password ${var.password} ./ansible/playbook.yml"
    working_dir = path.module
  }
  
}