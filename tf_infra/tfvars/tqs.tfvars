######## Enabled Modules ############
enable_module_rg                    = __enable_module_rg__
enable_module_vnet                  = __enable_module_vnet__
enable_module_subnetaks             = __enable_module_subnetaks__
enable_module_subnetpvt             = __enable_module_subnetpvt__
enable_module_loganalytics          = __enable_module_loganalytics__
enable_module_storageaccount        = __enable_module_storageaccount__
enable_module_aks                   = __enable_module_aks__
enable_module_bastion               = __enable_module_bastion__
enable_module_jumpervm              = __enable_module_jumpervm__
enable_module_keyvault              = __enable_module_keyvault__

####### Basic Info ##################
subscription_id     = __subscription_id__
project_name        = __project_name__
region              = __region__
environment         = __env__
resource_groups     = __resource_groups__

########### Network #################
vnet                        = __vnet__ 
aks_subnet                  = __subnet_aks__
aks_subnet_security_rules   = __subnet_aks_security_rules__
pvt_subnet                  = __subnet_pvt__
pvt_subnet_security_rules   = __subnet_pvt_security_rules__

########## Log Analytics ############
log_analytics_workspace_sku     =  __log_analytics_workspace_sku__
log_analytics                   = __log_analytics__
log_anatytics_workspaces        = __log_anatytics_workspaces__

######## Storage ACCOUNT ##########
storage_access_tier                       = __stg_access_tier__
storage_account_kind                      = __stg_account_kind__
storage_replication_type                  = __stg_replication_type__
storage_account_tier                      = __stg_account_tier__
storage_container_name                    = __stg_container_name__
storage_container_access_type             = __stg_container_access_type__
storage_file_share_name                   = __stg_file_share_name__
storage_file_share_quota                  = __stg_file_share_quota__
storage_default_action                    = __stg_default_action__
storage_allow_blob_public_access          = __stg_allow_blob_public_access__

######### KEY VAULT ################
keyvault_sku = __keyvault_sku__

######### BASTION & JUMPER VM #####
bastion_subnet_prefix = __bastion_subnet_prefix__
bastion_sku           = __bastion_sku__
jumper_vm_size        = __jumper_vm_size__
jumper_admin_username = __jumper_admin_username__

############ AKS #################
aks_service_cidr        = __aks_service_cidr__
aks_dns_service_ip      = __aks_dns_service_ip__
aks_version             = __aks_version__
aks_max_node_count      = __aks_max_node_count__
aks_min_node_count      = __aks_min_node_count__
aks_node_vm_size        = __aks_node_vm_size__

######## AKS MONITORING ##########
aks_log_data_collection_interval                      = __aks_log_dc_interval__
aks_log_namespace_filtering_mode_for_data_collection  = __aks_log_ns_filtering_mode_for_dc__
aks_log_namespaces_for_data_collection                = __aks_log_ns_for_dc__
aks_log_enableContainerLogV2                          = __aks_log_enableContainerLogV2__
aks_log_streams                                       = __aks_log_streams__
acr_sku                                               = __acr_sku__



