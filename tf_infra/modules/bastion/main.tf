# Azure Bastion requires a subnet named exactly AzureBastionSubnet (minimum /27, /26 recommended)
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.bastion_subnet_prefix]
}

resource "azurerm_public_ip" "bastion_pip" {
  name                = "pip-bastion-${var.proj_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-${var.proj_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.bastion_sku
  scale_units         = var.bastion_sku == "Standard" ? 2 : 2

  tunneling_enabled  = var.bastion_sku == "Standard" ? true : false
  ip_connect_enabled = var.bastion_sku == "Standard" ? true : false
  copy_paste_enabled = true

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }

  depends_on = [azurerm_subnet.bastion_subnet, azurerm_public_ip.bastion_pip]
}
