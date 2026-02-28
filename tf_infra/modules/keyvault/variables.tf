variable "location" {
  type        = string
  description = "Azure region"
}

variable "rg_name" {
  type        = string
  description = "Resource group name where the Key Vault will be created"
}

variable "environment" {
  type        = string
  description = "Environment (des/tqs/prd)"
}

variable "proj_name" {
  type        = string
  description = "Project name — used in the Key Vault name (kv-<proj>-<env>, max 24 chars total)"
}

variable "sku_name" {
  type        = string
  description = "Key Vault SKU: standard or premium"
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be standard or premium."
  }
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Soft-delete retention period in days (7–90)"
  default     = 7
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Enable purge protection. Set to false for non-prod to allow clean terraform destroy."
  default     = false
}
