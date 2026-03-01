# create virtual network 
resource "azurerm_virtual_network" "virtual_network" {
  name                = "vnet-${var.proj_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.address_space

  # Drop unencrypted inter-VM traffic within the VNet (requires compatible VM SKUs)
  encryption {
    enforcement = "AllowUnencrypted"
  }

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }
}

