output "bastion_id" {
  value       = azurerm_bastion_host.bastion.id
  description = "Bastion Host resource ID"
}

output "bastion_name" {
  value       = azurerm_bastion_host.bastion.name
  description = "Bastion Host name"
}

output "bastion_public_ip" {
  value       = azurerm_public_ip.bastion_pip.ip_address
  description = "Public IP address of the Bastion Host"
}

output "bastion_subnet_id" {
  value       = azurerm_subnet.bastion_subnet.id
  description = "AzureBastionSubnet ID"
}
