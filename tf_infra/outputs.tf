# ── AKS ─────────────────────────────────────────────────────────────────────
output "aks_name" {
  value       = var.enable_module_aks ? module.aks[0].aks_cluster_name : ""
  description = "AKS cluster name — used by helm-deploy workflow to set kubectl context"
}

output "aks_cluster_id" {
  value       = var.enable_module_aks ? module.aks[0].aks_cluster_id : ""
  description = "AKS cluster resource ID"
}

output "aks_cluster_fqdn" {
  value       = var.enable_module_aks ? module.aks[0].aks_cluster_fqdn : ""
  description = "FQDN of the AKS API server"
}

# ── Resource Groups ──────────────────────────────────────────────────────────
output "resource_group_name" {
  value       = var.enable_module_rg ? module.rg["aks"].rg_name : ""
  description = "Name of the AKS resource group — used by helm-deploy workflow"
}

output "resource_group_vnet_name" {
  value       = var.enable_module_rg ? module.rg["vnet"].rg_name : ""
  description = "Name of the VNet resource group"
}

output "resource_group_resources_name" {
  value       = var.enable_module_rg ? module.rg["resources"].rg_name : ""
  description = "Name of the shared resources resource group"
}

# ── ACR ──────────────────────────────────────────────────────────────────────
output "acr_login_server" {
  value       = var.enable_module_aks ? module.aks[0].acr_login_server : ""
  description = "ACR login server URL (e.g. acrsiadadesazurecr.io)"
}

output "acr_name" {
  value       = var.enable_module_aks ? module.aks[0].acr_name : ""
  description = "ACR registry name"
}
