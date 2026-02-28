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
