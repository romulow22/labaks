resource "azurerm_user_assigned_identity" "jumper_identity" {
  name                = "id-jumper-${var.proj_name}-${var.environment}"
  resource_group_name = var.rg_name
  location            = var.location
}

# AKS RBAC Cluster Admin — grants full Kubernetes API admin access
resource "azurerm_role_assignment" "jumper_aks_admin" {
  scope                            = var.aks_cluster_id
  role_definition_name             = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id                     = azurerm_user_assigned_identity.jumper_identity.principal_id
  skip_service_principal_aad_check = true
}

# Cluster User Role — allows az aks get-credentials to fetch kubeconfig
resource "azurerm_role_assignment" "jumper_aks_user" {
  scope                            = var.aks_cluster_id
  role_definition_name             = "Azure Kubernetes Service Cluster User Role"
  principal_id                     = azurerm_user_assigned_identity.jumper_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_network_interface" "jumper_nic" {
  name                = "nic-jumper-${var.proj_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    # No public IP — access is exclusively via Azure Bastion
  }

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }
}

# Cloud-init: install Azure CLI, kubectl, helm on first boot
locals {
  cloud_init = <<-EOT
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg
      - lsb-release
      - unzip
      - jq
    runcmd:
      # Azure CLI
      - curl -sL https://aka.ms/InstallAzureCLIDeb | bash
      # kubectl
      - curl -sLO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
      - install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
      # Helm
      - curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  EOT
}

resource "random_password" "jumper" {
  length           = 20
  special          = true
  override_special = "!@#$%^&*()-_=+[]{}"
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
}

resource "azurerm_key_vault_secret" "jumper_password" {
  name         = "jumper-vm-password"
  value        = random_password.jumper.result
  key_vault_id = var.key_vault_id

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }

  depends_on = [azurerm_role_assignment.jumper_aks_admin]
}

# Grant the jumper identity read access to secrets in the Key Vault
resource "azurerm_role_assignment" "jumper_kv_secrets_user" {
  scope                            = var.key_vault_id
  role_definition_name             = "Key Vault Secrets User"
  principal_id                     = azurerm_user_assigned_identity.jumper_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_linux_virtual_machine" "jumper" {
  name                            = "vm-jumper-${var.proj_name}-${var.environment}"
  location                        = var.location
  resource_group_name             = var.rg_name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = random_password.jumper.result
  disable_password_authentication = false

  # Spot instance for DES to reduce lab costs
  priority        = var.environment == "des" ? "Spot" : "Regular"
  eviction_policy = var.environment == "des" ? "Deallocate" : null
  max_bid_price   = var.environment == "des" ? -1 : null

  network_interface_ids = [azurerm_network_interface.jumper_nic.id]

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.jumper_identity.id]
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.environment == "prd" ? "Premium_LRS" : "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  custom_data = base64encode(local.cloud_init)

  tags = {
    Environment = var.environment
    Project     = var.proj_name
    Role        = "jumper"
  }

  depends_on = [
    azurerm_role_assignment.jumper_aks_admin,
    azurerm_role_assignment.jumper_aks_user,
    azurerm_key_vault_secret.jumper_password,
  ]
}
