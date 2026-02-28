resource "azurerm_log_analytics_workspace" "workspace" {
  for_each                   = var.workspaces
  name                       = "law-${each.key}-${var.proj_name}-${var.environment}"
  resource_group_name        = var.rg_name
  location                   = var.location
  sku                        = var.workspace_sku
  retention_in_days          = each.value.retention_days
  internet_ingestion_enabled = true
  internet_query_enabled     = true
  # Force Entra ID auth for all workspace queries — disables legacy workspace keys
  local_authentication_enabled = false
  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }
}

locals {
  filtered_workspaces = { for k, v in var.workspaces : k => v if v.solution_name != "" }
}

resource "azurerm_log_analytics_solution" "solution" {
  for_each              = local.filtered_workspaces
  solution_name         = each.value.solution_name
  location              = var.location
  resource_group_name   = var.rg_name
  workspace_resource_id = azurerm_log_analytics_workspace.workspace[each.key].id
  workspace_name        = azurerm_log_analytics_workspace.workspace[each.key].name

  dynamic "plan" {
    for_each = each.value.solution_plan_map
    content {
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  depends_on = [
    azurerm_log_analytics_workspace.workspace,
  ]
}