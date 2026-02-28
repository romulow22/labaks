variable "location" {
  type        = string
  description = "Azure region"
}

variable "rg_name" {
  type        = string
  description = "Resource group name where the VM will be created"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the jumper VM NIC — should be pvt subnet (no public IP)"
}

variable "environment" {
  type        = string
  description = "Environment (des/tqs/prd)"
}

variable "proj_name" {
  type        = string
  description = "Project name"
}

variable "vm_size" {
  type        = string
  description = "Azure VM size for the jumper VM"
  default     = "Standard_B2s"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the jumper VM"
  default     = "azureadmin"
}

variable "key_vault_id" {
  type        = string
  description = "Resource ID of the Key Vault where the generated VM password will be stored"
}

variable "aks_cluster_id" {
  type        = string
  description = "Resource ID of the AKS cluster — used to scope RBAC role assignments"
}
