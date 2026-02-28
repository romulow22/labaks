resource "azurerm_container_registry" "acr" {
  name                = "acr${var.proj_name}${var.environment}"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = false

  # Zone redundancy requires Premium SKU
  zone_redundancy_enabled = var.sku == "Premium" ? true : false

  # Auto-purge untagged manifests (Standard and Premium only)
  retention_policy_in_days = var.sku != "Basic" ? 7 : null

  # Quarantine policy: images must pass scanning before being pullable (Premium)
  quarantine_policy_enabled = var.sku == "Premium" ? true : false

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = var.aks_identity_principal_id
  skip_service_principal_aad_check = true
}
