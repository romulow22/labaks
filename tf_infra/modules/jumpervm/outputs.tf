output "jumper_vm_id" {
  value       = azurerm_linux_virtual_machine.jumper.id
  description = "Jumper VM resource ID"
}

output "jumper_vm_name" {
  value       = azurerm_linux_virtual_machine.jumper.name
  description = "Jumper VM name"
}

output "jumper_private_ip" {
  value       = azurerm_network_interface.jumper_nic.private_ip_address
  description = "Private IP address of the jumper VM"
}

output "jumper_identity_principal_id" {
  value       = azurerm_user_assigned_identity.jumper_identity.principal_id
  description = "Principal ID of the jumper VM managed identity"
}

output "jumper_identity_client_id" {
  value       = azurerm_user_assigned_identity.jumper_identity.client_id
  description = "Client ID of the jumper VM managed identity — use with az login --identity"
}

output "jumper_password_secret_name" {
  value       = azurerm_key_vault_secret.jumper_password.name
  description = "Name of the Key Vault secret holding the jumper VM password"
}
