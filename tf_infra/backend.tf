# backend
terraform {
  backend "azurerm" {
    resource_group_name  = "__BackendAzureRmResourceGroupName__"
    storage_account_name = "__BackendAzureRmStorageAccountName__"
    container_name       = "__BackendAzureRmContainerName__"
    key                  = "__BackendAzureRmKey__"
    subscription_id      = "__BackendAzureRmSubscriptionId__"
  }
}
