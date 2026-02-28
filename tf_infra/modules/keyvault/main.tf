data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                          = "kv-${var.proj_name}-${var.environment}"
  location                      = var.location
  resource_group_name           = var.rg_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = var.sku_name
  enable_rbac_authorization     = true
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = true

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }
}

# Grant the deploying identity Secrets Officer so Terraform can write/read secrets
resource "azurerm_role_assignment" "kv_deployer_secrets_officer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Grant the deploying identity Key Vault Administrator for key/cert management
resource "azurerm_role_assignment" "kv_deployer_admin" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}
