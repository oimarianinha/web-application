output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "public_ip_address" {
  value = azurerm_public_ip.acme-public-ip.*.ip_address
}
output "vm_private_ip_address" {
  value = azurerm_linux_virtual_machine.vms.*.private_ip_address
}
