variable "proj_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment (des/tqs/prd)"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "aks_cluster_id" {
  type        = string
  description = "AKS cluster resource ID"
}

variable "aks_cluster_name" {
  type        = string
  description = "AKS cluster name (used in DCR resource name)"
}

variable "workspace_id" {
  type        = string
  description = "Log Analytics workspace resource ID"
}

variable "data_collection_interval" {
  type        = string
  description = "Log data collection interval (e.g. 1m)"
  default     = "1m"
}

variable "namespace_filtering_mode_for_data_collection" {
  type        = string
  description = "Namespace filtering mode for the DCR: Off, Include, or Exclude"
  default     = "Off"
  validation {
    condition     = contains(["Off", "Include", "Exclude"], var.namespace_filtering_mode_for_data_collection)
    error_message = "Must be Off, Include, or Exclude."
  }
}

variable "namespaces_for_data_collection" {
  type        = list(string)
  description = "Namespaces to include/exclude for log data collection"
  default     = ["kube-system", "gatekeeper-system", "azure-arc"]
}

variable "enableContainerLogV2" {
  type        = bool
  description = "Enable Container Log V2 schema"
  default     = true
}

variable "streams" {
  type        = list(string)
  description = "Log streams to collect via Container Insights DCR"
  default     = ["Microsoft-ContainerLog", "Microsoft-ContainerLogV2", "Microsoft-KubeEvents", "Microsoft-KubePodInventory", "Microsoft-KubeNodeInventory", "Microsoft-KubePVInventory", "Microsoft-KubeServices", "Microsoft-KubeMonAgentEvents", "Microsoft-InsightsMetrics", "Microsoft-ContainerInventory", "Microsoft-ContainerNodeInventory", "Microsoft-Perf"]
}
