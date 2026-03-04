# Orchestrator — wires cluster, ACR, monitoring, and addons sub-modules

module "cluster" {
  source                       = "../aks_cluster"
  proj_name                    = var.proj_name
  environment                  = var.environment
  location                     = var.location
  rg_name                      = var.rg_name
  rg_id                        = var.rg_id
  cluster_version              = var.cluster_version
  node_vm_size                 = var.node_vm_size
  system_node_vm_size          = var.system_node_vm_size
  max_count                    = var.max_count
  min_count                    = var.min_count
  subnetaks_id                 = var.subnetaks_id
  service_cidr                 = var.service_cidr
  dns_service_ip               = var.dns_service_ip
  workspace_id                 = var.workspace_id
  automatic_upgrade_channel    = var.automatic_upgrade_channel
  node_os_upgrade_channel      = var.node_os_upgrade_channel
  image_cleaner_enabled        = var.image_cleaner_enabled
  image_cleaner_interval_hours = var.image_cleaner_interval_hours
  istio_revision               = var.istio_revision
}

module "acr" {
  source                    = "../acr"
  proj_name                 = var.proj_name
  environment               = var.environment
  location                  = var.location
  rg_name                   = var.rg_name
  sku                       = var.acr_sku
  aks_identity_principal_id = module.cluster.user_assigned_identity_principal_id
  depends_on                = [module.cluster]
}

module "monitoring" {
  source                                       = "../aks_monitoring"
  proj_name                                    = var.proj_name
  environment                                  = var.environment
  location                                     = var.location
  rg_name                                      = var.rg_name
  aks_cluster_id                               = module.cluster.aks_cluster_id
  aks_cluster_name                             = module.cluster.aks_cluster_name
  workspace_id                                 = var.workspace_id
  data_collection_interval                     = var.data_collection_interval
  namespace_filtering_mode_for_data_collection = var.namespace_filtering_mode_for_data_collection
  namespaces_for_data_collection               = var.namespaces_for_data_collection
  enable_container_log_v2                      = var.enable_container_log_v2
  streams                                      = var.streams
  depends_on                                   = [module.cluster]
}

# ─── Add-ons (akv2k8s) ───────────────────────────────────────────────────────
module "addons" {
  source                 = "../aks_addons"
  environment            = var.environment
  aks_cluster_id         = module.cluster.aks_cluster_id
  aks_identity_client_id = module.cluster.user_assigned_identity_client_id
  akv2k8s_chart_version  = var.akv2k8s_chart_version
  depends_on             = [module.cluster, module.monitoring]
}

