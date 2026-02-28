# Azure Provider
terraform {
  required_version = ">=1.10.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~>2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

# configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = false
      skip_shutdown_and_force_delete = false
    }
  }
}

# Helm provider uses AKS credentials directly from the data source in main.tf.
# Falls back to a no-op localhost endpoint when AKS has not been provisioned yet
# (e.g. first run with enable_module_aks = false) to avoid provider init errors.
provider "helm" {
  kubernetes = {
    host = (
      var.enable_module_aks
      ? data.azurerm_kubernetes_cluster.aks[0].kube_config[0].host
      : "https://localhost"
    )
    client_certificate = (
      var.enable_module_aks
      ? base64decode(data.azurerm_kubernetes_cluster.aks[0].kube_config[0].client_certificate)
      : ""
    )
    client_key = (
      var.enable_module_aks
      ? base64decode(data.azurerm_kubernetes_cluster.aks[0].kube_config[0].client_key)
      : ""
    )
    cluster_ca_certificate = (
      var.enable_module_aks
      ? base64decode(data.azurerm_kubernetes_cluster.aks[0].kube_config[0].cluster_ca_certificate)
      : ""
    )
  }
}

