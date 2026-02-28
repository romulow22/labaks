module "rg" {
  source       = "./modules/resourcegroup"
  for_each     = var.enable_module_rg ? var.resource_groups : {}
  location     = var.region
  environment  = var.environment
  proj_name    = var.project_name
  service_name = each.value
}


# creating virtual network
module "vnet" {
  count         = var.enable_module_vnet ? 1 : 0
  source        = "./modules/vnet"
  location      = var.region
  address_space = var.vnet
  environment   = var.environment
  proj_name     = var.project_name
  rg_name       = module.rg["vnet"].rg_name
  depends_on    = [module.rg]
}

# creating subnet for aks
module "subnetaks" {
  count                 = var.enable_module_subnetaks ? 1 : 0
  source                = "./modules/subnet"
  subnet_name           = "aks"
  rg_name               = module.rg["vnet"].rg_name
  vnet_name             = module.vnet[0].vnet_name
  subnet_address_prefix = var.aks_subnet
  environment           = var.environment
  proj_name             = var.project_name
  location              = var.region
  security_rules        = var.aks_subnet_security_rules
  depends_on            = [module.vnet]
}

# creating subnet for pvt
module "subnetpvt" {
  count                 = var.enable_module_subnetpvt ? 1 : 0
  source                = "./modules/subnet"
  subnet_name           = "pvt"
  rg_name               = module.rg["vnet"].rg_name
  vnet_name             = module.vnet[0].vnet_name
  subnet_address_prefix = var.pvt_subnet
  environment           = var.environment
  proj_name             = var.project_name
  location              = var.region
  security_rules        = var.pvt_subnet_security_rules
  depends_on            = [module.vnet]
}


module "loganalytics" {
  source        = "./modules/loganalytics"
  for_each      = var.enable_module_loganalytics ? var.log_analytics : {}
  rg_name       = module.rg["${each.value}"].rg_name
  environment   = var.environment
  proj_name     = var.project_name
  location      = var.region
  workspace_sku = var.log_analytics_workspace_sku
  workspaces = {
    (each.value) = var.log_analytics_workspaces["${each.value}"]
  }
  depends_on = [module.rg]
}

module "storageaccount" {
  count                     = var.enable_module_storageaccount ? 1 : 0
  source                    = "./modules/storageaccount"
  location                  = var.region
  proj_name                 = var.project_name
  environment               = var.environment
  rg_name                   = module.rg["resources"].rg_name
  rg_id                     = module.rg["resources"].rg_id
  aks_identity_principal_id = var.enable_module_aks ? module.aks[0].user_assigned_identity_principal_id : ""
  access_tier               = var.storage_access_tier
  account_kind              = var.storage_account_kind
  replication_type          = var.storage_replication_type
  account_tier              = var.storage_account_tier
  container_name            = var.storage_container_name
  container_access_type     = var.storage_container_access_type
  file_share_name           = var.storage_file_share_name
  file_share_quota          = var.storage_file_share_quota
  default_action            = var.storage_default_action
  workspace_id              = var.enable_module_loganalytics ? module.loganalytics["resources"].log_analytics_workspace_id["resources"] : ""
  depends_on                = [module.rg, module.aks, module.loganalytics]
}


# creating Key Vault (stores jumper VM password)
module "keyvault" {
  count       = var.enable_module_keyvault ? 1 : 0
  source      = "./modules/keyvault"
  location    = var.region
  proj_name   = var.project_name
  environment = var.environment
  rg_name     = module.rg["resources"].rg_name
  sku_name    = var.keyvault_sku
  depends_on  = [module.rg]
}

# creating Azure Bastion
module "bastion" {
  count                 = var.enable_module_bastion ? 1 : 0
  source                = "./modules/bastion"
  location              = var.region
  proj_name             = var.project_name
  environment           = var.environment
  rg_name               = module.rg["vnet"].rg_name
  vnet_name             = var.enable_module_vnet ? module.vnet[0].vnet_name : ""
  bastion_subnet_prefix = var.bastion_subnet_prefix
  bastion_sku           = var.bastion_sku
  depends_on            = [module.vnet]
}

# creating Jumper VM (access to AKS via Bastion)
module "jumpervm" {
  count          = var.enable_module_jumpervm ? 1 : 0
  source         = "./modules/jumpervm"
  location       = var.region
  proj_name      = var.project_name
  environment    = var.environment
  rg_name        = module.rg["resources"].rg_name
  subnet_id      = var.enable_module_subnetpvt ? module.subnetpvt[0].public_subnet_id : ""
  vm_size        = var.jumper_vm_size
  admin_username = var.jumper_admin_username
  key_vault_id   = var.enable_module_keyvault ? module.keyvault[0].key_vault_id : ""
  aks_cluster_id = var.enable_module_aks ? module.aks[0].aks_cluster_id : ""
  depends_on     = [module.subnetpvt, module.aks, module.keyvault]
}

# creating AKS
module "aks" {
  count                                        = var.enable_module_aks ? 1 : 0
  source                                       = "./modules/aks"
  rg_name                                      = module.rg["aks"].rg_name
  rg_id                                        = module.rg["aks"].rg_id
  location                                     = var.region
  proj_name                                    = var.project_name
  cluster_version                              = var.aks_version
  service_cidr                                 = var.aks_service_cidr
  dns_service_ip                               = var.aks_dns_service_ip
  environment                                  = var.environment
  max_count                                    = var.aks_max_node_count
  min_count                                    = var.aks_min_node_count
  subnetaks_id                                 = var.enable_module_subnetaks ? module.subnetaks[0].public_subnet_id : ""
  node_vm_size                                 = var.aks_node_vm_size
  workspace_id                                 = var.enable_module_loganalytics ? module.loganalytics["aks"].log_analytics_workspace_id["aks"] : ""
  streams                                      = var.aks_log_streams
  data_collection_interval                     = var.aks_log_data_collection_interval
  namespace_filtering_mode_for_data_collection = var.aks_log_namespace_filtering_mode_for_data_collection
  namespaces_for_data_collection               = var.aks_log_namespaces_for_data_collection
  enableContainerLogV2                         = var.aks_log_enableContainerLogV2
  acr_sku                                      = var.acr_sku
  automatic_upgrade_channel                    = var.aks_automatic_upgrade_channel
  node_os_upgrade_channel                      = var.aks_node_os_upgrade_channel
  image_cleaner_enabled                        = var.aks_image_cleaner_enabled
  image_cleaner_interval_hours                 = var.aks_image_cleaner_interval_hours
  depends_on                                   = [module.subnetaks, module.loganalytics]
}

# AKS credentials for the Helm provider — resolved after module.aks completes
data "azurerm_kubernetes_cluster" "aks" {
  count               = var.enable_module_aks ? 1 : 0
  name                = "aks-${var.project_name}-${var.environment}"
  resource_group_name = module.rg["aks"].rg_name
  depends_on          = [module.aks]
}


