output "aks_cluster_id" {
  value       = azurerm_kubernetes_cluster.aks.id
  description = "AKS cluster resource ID"
}

output "aks_cluster_name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "AKS cluster name"
}

output "aks_cluster_fqdn" {
  value       = azurerm_kubernetes_cluster.aks.fqdn
  description = "FQDN of the AKS cluster"
}

output "kube_config_raw" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
  description = "Raw kubeconfig content"
}

output "kube_config_host" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].host
  sensitive   = true
  description = "AKS API server host"
}

output "kube_config_client_certificate" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive   = true
  description = "AKS client certificate (base64)"
}

output "kube_config_client_key" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
  sensitive   = true
  description = "AKS client key (base64)"
}

output "kube_config_cluster_ca_certificate" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
  sensitive   = true
  description = "AKS cluster CA certificate (base64)"
}

output "user_assigned_identity_principal_id" {
  value       = azurerm_user_assigned_identity.aks_identity.principal_id
  description = "Principal ID of the AKS user-assigned identity"
}

output "user_assigned_identity_client_id" {
  value       = azurerm_user_assigned_identity.aks_identity.client_id
  description = "Client ID of the AKS user-assigned identity"
}

output "user_assigned_identity_id" {
  value       = azurerm_user_assigned_identity.aks_identity.id
  description = "Resource ID of the AKS user-assigned identity"
}
