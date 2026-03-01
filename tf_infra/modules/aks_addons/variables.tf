variable "environment" {
  type        = string
  description = "Environment (des/tqs/prd) — controls log level"
  validation {
    condition     = contains(["des", "tqs", "prd"], var.environment)
    error_message = "Environment must be des, tqs, or prd."
  }
}

variable "aks_cluster_id" {
  type        = string
  description = "AKS cluster resource ID — dependency anchor for all Helm releases"
}

variable "aks_identity_client_id" {
  type        = string
  description = "Client ID of the AKS user-assigned managed identity — used by akv2k8s for Workload Identity"
}

variable "akv2k8s_chart_version" {
  type        = string
  description = "Helm chart version for akv2k8s (Azure Key Vault to Kubernetes)"
  default     = "2.5.3"
}
