# create virtual network 
resource "azurerm_virtual_network" "virtual_network" {
  name                = "vnet-${var.proj_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.address_space
  dns_servers         = []

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }
}

