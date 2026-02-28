# ── cluster sub-module ──────────────────────────────────────────────────────
output "aks_cluster_id" {
  value       = module.cluster.aks_cluster_id
  description = "AKS cluster resource ID"
}

output "aks_cluster_name" {
  value       = module.cluster.aks_cluster_name
  description = "AKS cluster name"
}

output "aks_cluster_fqdn" {
  value       = module.cluster.aks_cluster_fqdn
  description = "FQDN of the AKS cluster"
}

# ── acr sub-module ──────────────────────────────────────────────────────────
output "acr_id" {
  value       = module.acr.acr_id
  description = "ACR resource ID"
}

output "acr_login_server" {
  value       = module.acr.acr_login_server
  description = "ACR login server URL"
}

output "acr_name" {
  value       = module.acr.acr_name
  description = "ACR registry name"
}

output "user_assigned_identity_principal_id" {
  value       = module.cluster.user_assigned_identity_principal_id
  description = "Principal ID of the AKS user-assigned identity"
}

output "user_assigned_identity_client_id" {
  value       = module.cluster.user_assigned_identity_client_id
  description = "Client ID of the AKS user-assigned identity"
}

output "kube_config_raw" {
  value       = module.cluster.kube_config_raw
  sensitive   = true
  description = "Raw kubeconfig content"
}

output "kube_config_host" {
  value       = module.cluster.kube_config_host
  sensitive   = true
  description = "AKS API server host"
}

output "kube_config_client_certificate" {
  value       = module.cluster.kube_config_client_certificate
  sensitive   = true
  description = "AKS client certificate (base64)"
}

output "kube_config_client_key" {
  value       = module.cluster.kube_config_client_key
  sensitive   = true
  description = "AKS client key (base64)"
}

output "kube_config_cluster_ca_certificate" {
  value       = module.cluster.kube_config_cluster_ca_certificate
  sensitive   = true
  description = "AKS cluster CA certificate (base64)"
}

# ── monitoring sub-module ────────────────────────────────────────────────────
output "dcr_id" {
  value       = module.monitoring.dcr_id
  description = "Data Collection Rule resource ID"
}

# ── addons sub-module ────────────────────────────────────────────────────────
output "akv2k8s_release_status" {
  value       = module.addons.akv2k8s_release_status
  description = "Helm release status of akv2k8s"
}

output "akv2k8s_namespace" {
  value       = module.addons.akv2k8s_namespace
  description = "Namespace where akv2k8s is deployed"
}



