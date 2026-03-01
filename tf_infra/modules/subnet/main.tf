# create public subnets
resource "azurerm_subnet" "public_subnet" {
  name                 = "subnet-${var.subnet_name}"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_address_prefix
}

# create network security group
resource "azurerm_network_security_group" "public_nsg" {
  name                = "nsg-${var.subnet_name}-${var.proj_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.rg_name

  dynamic "security_rule" {
    for_each = { for sg in var.security_rules : sg.name => sg }
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_ranges           = security_rule.value.source_port_ranges
      destination_port_ranges      = security_rule.value.destination_port_ranges
      source_address_prefixes      = security_rule.value.source_address_prefixes
      destination_address_prefixes = security_rule.value.destination_address_prefixes
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }
}

# associate NSG to public subnets
resource "azurerm_subnet_network_security_group_association" "nsg_associate_public" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}

