# subnetname
output "public_subnet_name" {
  value       = azurerm_subnet.public_subnet.name
  description = "Name of the subnet"
}

# vnet public subnets
output "public_subnet_id" {
  value       = azurerm_subnet.public_subnet.id
  description = "Public Subnet ID"
}

