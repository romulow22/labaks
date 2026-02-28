resource "azurerm_storage_account" "storage_account" {
  name                     = "stg${var.proj_name}${var.environment}"
  resource_group_name      = var.rg_name
  location                 = var.location
  access_tier              = var.access_tier
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  is_hns_enabled           = false

  # azurerm 4.x: replaces deprecated allow_blob_public_access
  allow_nested_items_to_be_public = var.allow_blob_public_access
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  shared_access_key_enabled       = true

  # Disable local SSH users and SFTP — not needed, prefer Entra ID auth
  local_user_enabled = false
  sftp_enabled       = false

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  network_rules {
    default_action = var.default_action
    bypass         = ["AzureServices"]
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }
}


resource "azurerm_storage_container" "storage_container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = var.container_access_type
}


resource "azurerm_storage_share" "storage_share" {
  name               = var.file_share_name
  storage_account_id = azurerm_storage_account.storage_account.id
  quota              = var.file_share_quota
}

# RBAC: grant AKS identity Storage Blob Data Contributor scoped to the storage account
resource "azurerm_role_assignment" "storage_role" {
  count                            = var.aks_identity_principal_id != "" ? 1 : 0
  scope                            = azurerm_storage_account.storage_account.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = var.aks_identity_principal_id
  skip_service_principal_aad_check = true
}

# Diagnostic settings targeting blob sub-resource
resource "azurerm_monitor_diagnostic_setting" "diag_storage" {
  name                       = "diag-${azurerm_storage_account.storage_account.name}"
  target_resource_id         = "${azurerm_storage_account.storage_account.id}/blobServices/default"
  log_analytics_workspace_id = var.workspace_id

  enabled_metric {
    category = "Transaction"
  }
}