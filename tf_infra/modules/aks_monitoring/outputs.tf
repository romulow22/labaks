output "dcr_id" {
  value       = azurerm_monitor_data_collection_rule.dcr.id
  description = "Data Collection Rule resource ID"
}

output "dcr_name" {
  value       = azurerm_monitor_data_collection_rule.dcr.name
  description = "Data Collection Rule name"
}

output "dcra_id" {
  value       = azurerm_monitor_data_collection_rule_association.dcra.id
  description = "Data Collection Rule Association resource ID"
}
