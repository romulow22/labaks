# create public subnets
resource "azurerm_subnet" "public_subnet" {
  name                 = "subnet-${var.subnet_name}"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_address_prefix
}

