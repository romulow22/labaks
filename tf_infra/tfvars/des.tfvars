######## Enabled Modules ############
enable_module_rg             = true
enable_module_vnet           = true
enable_module_subnetaks      = true
enable_module_subnetpvt      = true
enable_module_loganalytics   = true
enable_module_storageaccount = true
enable_module_aks            = true
enable_module_bastion        = true
enable_module_jumpervm       = true
enable_module_keyvault       = true

####### Basic Info ##################
subscription_id = "__subscription_id__"
project_name    = "__project_name__"
region          = "brazilsouth"
environment     = "des"
resource_groups = {
  "vnet"      = "vnet"
  "aks"       = "aks"
  "resources" = "resources"
}

########### Network #################
vnet       = ["10.0.0.0/16"]
aks_subnet = ["10.0.1.0/24"]
pvt_subnet = ["10.0.2.0/24"]

aks_subnet_security_rules = [
  {
    name                         = "allow-https-inbound"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_ranges           = ["*"]
    destination_port_ranges      = ["443"]
    source_address_prefixes      = ["*"]
    destination_address_prefixes = ["*"]
  },
  {
    name                         = "allow-http-inbound"
    priority                     = 110
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_ranges           = ["*"]
    destination_port_ranges      = ["80"]
    source_address_prefixes      = ["*"]
    destination_address_prefixes = ["*"]
  }
]

pvt_subnet_security_rules = [
  {
    name                         = "allow-vnet-inbound"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_ranges           = ["*"]
    destination_port_ranges      = ["*"]
    source_address_prefixes      = ["VirtualNetwork"]
    destination_address_prefixes = ["VirtualNetwork"]
  }
]

########## Log Analytics ############
log_analytics_workspace_sku = "PerGB2018"

log_analytics = {
  "aks"       = "aks"
  "resources" = "resources"
}

log_analytics_workspaces = {
  "aks" = {
    retention_days = 30
    solution_name  = "ContainerInsights"
    solution_plan_map = {
      "ContainerInsights" = {
        product   = "OMSGallery/ContainerInsights"
        publisher = "Microsoft"
      }
    }
  }
  "resources" = {
    retention_days    = 30
    solution_name     = ""
    solution_plan_map = {}
  }
}

######## Storage ACCOUNT ##########
storage_access_tier              = "Hot"
storage_account_kind             = "StorageV2"
storage_replication_type         = "LRS"
storage_account_tier             = "Standard"
storage_container_name           = "des-container"
storage_container_access_type    = "private"
storage_file_share_name          = "des-fileshare"
storage_file_share_quota         = 50
storage_default_action           = "Allow"
storage_allow_blob_public_access = false

######### KEY VAULT ################
keyvault_sku = "standard"

######### BASTION & JUMPER VM #####
bastion_subnet_prefix = "10.0.3.0/26"
bastion_sku           = "Standard"
jumper_vm_size        = "Standard_B2s"
jumper_admin_username = "azureadmin"

############ AKS #################
aks_service_cidr   = "10.100.0.0/16"
aks_dns_service_ip = "10.100.0.10"
aks_version        = "1.31"
aks_max_node_count = 3
aks_min_node_count = 1
aks_node_vm_size   = "Standard_D2s_v3"
acr_sku            = "Basic"

######## AKS UPGRADE / MAINTENANCE ##########
aks_automatic_upgrade_channel    = "patch"
aks_node_os_upgrade_channel      = "SecurityPatch"
aks_image_cleaner_enabled        = true
aks_image_cleaner_interval_hours = 48
istio_revision                   = "asm-1-28"
akv2k8s_chart_version            = "2.5.3"

######## AKS MONITORING ##########
aks_log_data_collection_interval                     = "1m"
aks_log_namespace_filtering_mode_for_data_collection = "Off"
aks_log_namespaces_for_data_collection               = ["kube-system", "gatekeeper-system", "azure-arc"]
aks_log_enable_container_log_v2                      = true
aks_log_streams = [
  "Microsoft-ContainerLog",
  "Microsoft-ContainerLogV2",
  "Microsoft-KubeEvents",
  "Microsoft-KubePodInventory",
  "Microsoft-KubeNodeInventory",
  "Microsoft-KubePVInventory",
  "Microsoft-KubeServices",
  "Microsoft-KubeMonAgentEvents",
  "Microsoft-InsightsMetrics",
  "Microsoft-ContainerInventory",
  "Microsoft-ContainerNodeInventory",
  "Microsoft-Perf"
]



