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
