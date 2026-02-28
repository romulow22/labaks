# subnet CIDRs
variable "subnet_address_prefix" {
  type        = list(string)
  description = "CIDR of subnet"
}

variable "rg_name"{
  type        = string
  description = "rg Name"
}

variable "vnet_name"{
  type        = string
  description = "vnet Name"
}

variable "subnet_name"{
  type        = string
  description = "subnet_name"
}

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

variable "proj_name"{
  type        = string
  description = "project Name"
}

variable "security_rules" {
  description = "A list of security rules to be created."
  type = list(object({
    name                          = string
    priority                      = number
    direction                     = string 
    access                        = string
    protocol                      = string
    source_port_ranges            = list(string)
    destination_port_ranges       = list(string)
    source_address_prefixes       = list(string)
    destination_address_prefixes  = list(string)
    }))
}