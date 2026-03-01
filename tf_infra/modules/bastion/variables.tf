variable "location" {
  type        = string
  description = "Azure region"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "vnet_name" {
  type        = string
  description = "Virtual network name — the Bastion subnet will be created inside this VNet"
}

variable "bastion_subnet_prefix" {
  type        = string
  description = "CIDR prefix for AzureBastionSubnet — minimum /27, /26 recommended"
}

variable "environment" {
  type        = string
  description = "Environment (des/tqs/prd)"
}

variable "proj_name" {
  type        = string
  description = "Project name"
}

variable "bastion_sku" {
  type        = string
  description = "Bastion SKU: Basic or Standard. Standard enables tunneling and IP connect."
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard"], var.bastion_sku)
    error_message = "bastion_sku must be Basic or Standard."
  }
}

variable "bastion_scale_units" {
  type        = number
  description = "Number of scale units for the Standard SKU Bastion host (2–50). Ignored for Basic SKU."
  default     = 2
  validation {
    condition     = var.bastion_scale_units >= 2 && var.bastion_scale_units <= 50
    error_message = "bastion_scale_units must be between 2 and 50."
  }
}
