output "key_vault_id" {
  value       = azurerm_key_vault.kv.id
  description = "Resource ID of the Key Vault"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.kv.vault_uri
  description = "URI of the Key Vault (https://<name>.vault.azure.net/)"
}

output "key_vault_name" {
  value       = azurerm_key_vault.kv.name
  description = "Name of the Key Vault"
}
