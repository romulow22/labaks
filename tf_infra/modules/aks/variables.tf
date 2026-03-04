# location
variable "location" {
  type        = string
  description = "location of the resources"
}

# environment
variable "environment" {
  type        = string
  description = "environment"
}

variable "proj_name" {
  type        = string
  description = "project Name"
}

# max node count
variable "max_count" {
  type        = number
  description = "Maximum node count for worker node"
}

# min node count
variable "min_count" {
  type        = number
  description = "Minimum node count for worker node"
}

# max node count for system pool
variable "system_max_count" {
  type        = number
  description = "Maximum node count for system node pool"
}

# min node count for system pool
variable "system_min_count" {
  type        = number
  description = "Minimum node count for system node pool"
}

# subnet ID
variable "subnetaks_id" {
  type        = string
  description = "Subnet ID for worker node"
}

# Size of worker nodes
variable "node_vm_size" {
  type        = string
  description = "Worker nodes size"
}

variable "system_node_vm_size" {
  type        = string
  description = "System node pool VM size"
  default     = "Standard_D2s_v3"
}

variable "cluster_version" {
  type        = string
  description = "AKS version"
}

variable "service_cidr" {
  type        = string
  description = "Aks Service CIDRs"
}

variable "dns_service_ip" {
  type        = string
  description = "Aks DNS Service Ip"
}

variable "rg_name" {
  type        = string
  description = "resource group name"
}

variable "rg_id" {
  type        = string
  description = "resource group id"
}


variable "workspace_id" {
  type        = string
  description = "Log Analytics workspace resource ID for Container Insights"
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

variable "enable_container_log_v2" {
  type        = bool
  description = "Enable Container Log V2 schema"
  default     = true
}

variable "streams" {
  type        = list(string)
  description = "Log streams to collect via Container Insights DCR"
  default     = ["Microsoft-ContainerLog", "Microsoft-ContainerLogV2", "Microsoft-KubeEvents", "Microsoft-KubePodInventory", "Microsoft-KubeNodeInventory", "Microsoft-KubePVInventory", "Microsoft-KubeServices", "Microsoft-KubeMonAgentEvents", "Microsoft-InsightsMetrics", "Microsoft-ContainerInventory", "Microsoft-ContainerNodeInventory", "Microsoft-Perf"]
}

variable "acr_sku" {
  type        = string
  description = "ACR SKU: Basic, Standard, or Premium"
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "ACR SKU must be Basic, Standard, or Premium."
  }
}

variable "automatic_upgrade_channel" {
  type        = string
  description = "AKS auto-upgrade channel: none, patch, rapid, stable, or node-image"
  default     = "patch"
  validation {
    condition     = contains(["none", "patch", "rapid", "stable", "node-image"], var.automatic_upgrade_channel)
    error_message = "automatic_upgrade_channel must be none, patch, rapid, stable, or node-image."
  }
}

variable "node_os_upgrade_channel" {
  type        = string
  description = "Node OS upgrade channel: None, Unmanaged, NodeImage, or SecurityPatch"
  default     = "SecurityPatch"
  validation {
    condition     = contains(["None", "Unmanaged", "NodeImage", "SecurityPatch"], var.node_os_upgrade_channel)
    error_message = "node_os_upgrade_channel must be None, Unmanaged, NodeImage, or SecurityPatch."
  }
}

variable "image_cleaner_enabled" {
  type        = bool
  description = "Enable image cleaner to remove unused container images from nodes"
  default     = true
}

variable "image_cleaner_interval_hours" {
  type        = number
  description = "Interval in hours between image cleaner runs"
  default     = 48
}

variable "istio_revision" {
  type        = string
  description = "Istio revision to deploy via the AKS managed add-on (e.g. asm-1-28)"
  default     = "asm-1-28"
}

variable "akv2k8s_chart_version" {
  type        = string
  description = "Helm chart version for akv2k8s (Azure Key Vault to Kubernetes)"
  default     = "2.5.3"
}

