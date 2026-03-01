resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                = "MSCI-${var.location}-${var.aks_cluster_name}"
  resource_group_name = var.rg_name
  location            = var.location
  kind                = "Linux"

  destinations {
    log_analytics {
      workspace_resource_id = var.workspace_id
      name                  = "ciworkspace"
    }
  }

  data_flow {
    streams      = var.streams
    destinations = ["ciworkspace"]
  }

  data_sources {
    extension {
      streams        = var.streams
      extension_name = "ContainerInsights"
      extension_json = jsonencode({
        "dataCollectionSettings" : {
          "interval" : var.data_collection_interval,
          "namespaceFilteringMode" : var.namespace_filtering_mode_for_data_collection,
          "namespaces" : var.namespaces_for_data_collection,
          "enableContainerLogV2" : var.enable_container_log_v2
        }
      })
      name = "ContainerInsightsExtension"
    }
  }

  description = "DCR for Azure Monitor Container Insights"

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }
}

resource "azurerm_monitor_data_collection_rule_association" "dcra" {
  name                    = "ContainerInsightsExtension"
  target_resource_id      = var.aks_cluster_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id
  description             = "Association of container insights data collection rule. Deleting this association will break the data collection for this AKS Cluster."

  depends_on = [azurerm_monitor_data_collection_rule.dcr]
}
