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

variable "sku" {
  type        = string
  description = "ACR SKU: Basic, Standard, or Premium"
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "ACR SKU must be Basic, Standard, or Premium."
  }
}

variable "aks_identity_principal_id" {
  type        = string
  description = "Principal ID of the AKS user-assigned identity for AcrPull role assignment"
}
