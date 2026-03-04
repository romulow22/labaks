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

variable "rg_id" {
  type        = string
  description = "Resource group ID"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the AKS cluster"
}

variable "node_vm_size" {
  type        = string
  description = "VM size for cluster node pools"
}

variable "system_node_vm_size" {
  type        = string
  description = "VM size for system node pool (can differ from worker pool)"
  default     = "Standard_D2s_v3"
}

variable "max_count" {
  type        = number
  description = "Maximum node count for auto-scaling"
}

variable "min_count" {
  type        = number
  description = "Minimum node count for auto-scaling"
}

variable "subnetaks_id" {
  type        = string
  description = "Subnet ID for AKS node pools"
}

variable "service_cidr" {
  type        = string
  description = "CIDR range for Kubernetes services"
}

variable "dns_service_ip" {
  type        = string
  description = "IP address for the Kubernetes DNS service"
}

variable "workspace_id" {
  type        = string
  description = "Log Analytics workspace resource ID for OMS agent"
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
