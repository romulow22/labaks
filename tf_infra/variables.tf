variable "enable_module_rg" {
  description = "Flag to turn on or off the module"
  type        = bool
  default     = true
}

variable "enable_module_vnet" {
  description = "Flag to turn on or off the module"
  type        = bool
  default     = true
}

variable "enable_module_subnetaks" {
  description = "Flag to turn on or off the module"
  type        = bool
  default     = true
}

variable "enable_module_loganalytics" {
  description = "Flag to turn on or off the module"
  type        = bool
  default     = true
}

variable "enable_module_storageaccount" {
  description = "Flag to turn on or off the module"
  type        = bool
  default     = true
}

variable "enable_module_aks" {
  description = "Flag to turn on or off the module"
  type        = bool
  default     = true
}

variable "enable_module_subnetpvt" {
  description = "Flag to turn on or off the module"
  type        = bool
  default     = true
}

variable "enable_module_bastion" {
  description = "Flag to turn on or off the Azure Bastion module"
  type        = bool
  default     = true
}

variable "enable_module_jumpervm" {
  description = "Flag to turn on or off the Jumper VM module"
  type        = bool
  default     = true
}

# ========================== bastion variables ==========================
variable "bastion_subnet_prefix" {
  type        = string
  description = "CIDR prefix for AzureBastionSubnet — minimum /27, /26 recommended (e.g. 10.0.3.0/26)"
}

variable "bastion_sku" {
  type        = string
  description = "Bastion SKU: Basic or Standard. Standard enables native client tunneling."
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard"], var.bastion_sku)
    error_message = "bastion_sku must be Basic or Standard."
  }
}

variable "bastion_scale_units" {
  type        = number
  description = "Number of scale units for the Standard SKU Bastion host (2–50). Ignored for Basic SKU."
  default     = 2
  validation {
    condition     = var.bastion_scale_units >= 2 && var.bastion_scale_units <= 50
    error_message = "bastion_scale_units must be between 2 and 50."
  }
}

# ========================== jumper VM variables ==========================
variable "jumper_vm_size" {
  type        = string
  description = "Azure VM size for the Jumper VM"
  default     = "Standard_B2s"
}

variable "jumper_admin_username" {
  type        = string
  description = "Admin username for the Jumper VM"
  default     = "azureadmin"
}

# ========================== key vault variables ==========================
variable "enable_module_keyvault" {
  description = "Flag to turn on or off the Key Vault module"
  type        = bool
  default     = true
}

variable "keyvault_sku" {
  type        = string
  description = "Key Vault SKU: standard or premium"
  default     = "standard"
}

# Required by azurerm 4.x — subscription must be explicit in the provider block
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
  sensitive   = true
}

variable "resource_groups" {
  description = "Map of resource groups to create"
  type        = map(string)
}

# region
variable "region" {
  type        = string
  description = "Region"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

# Virtual Network CIDR
variable "vnet" {
  type        = list(string)
  description = "Virtual Network CIDR"
}

# subnet CIDRs
variable "aks_subnet" {
  type        = list(string)
  description = "AKS Subnet CIDRs"
}

# subnet CIDRs
variable "pvt_subnet" {
  type        = list(string)
  description = "Private Subnet CIDRs"
}

variable "pvt_subnet_security_rules" {
  description = "A list of security rules to be created."
  type = list(object({
    name                         = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_ranges           = list(string)
    destination_port_ranges      = list(string)
    source_address_prefixes      = list(string)
    destination_address_prefixes = list(string)
  }))
}

variable "aks_subnet_security_rules" {
  description = "A list of security rules to be created."
  type = list(object({
    name                         = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_ranges           = list(string)
    destination_port_ranges      = list(string)
    source_address_prefixes      = list(string)
    destination_address_prefixes = list(string)
  }))
}


# environment
variable "environment" {
  type        = string
  description = "Environment"
  validation {
    condition     = contains(["des", "tqs", "prd"], lower(var.environment))
    error_message = "Please choose between des, tqs or prd"
  }
}

# max node count 
variable "aks_max_node_count" {
  type        = number
  description = "Maximum node count for worker node"
}

# min node count 
variable "aks_min_node_count" {
  type        = number
  description = "Minimum node count for worker node"
}

# size of worker node
variable "aks_node_vm_size" {
  type        = string
  description = "Size of worker node"
}

variable "aks_version" {
  type        = string
  description = "Version of the AKS"
}

variable "aks_service_cidr" {
  type        = string
  description = "AKS Service CIDRs"
}

variable "aks_dns_service_ip" {
  type        = string
  description = "AKS DNS Service IP"
}

// ========================== storage account variables ==========================
variable "storage_account_kind" {
  description = "Specifies the account kind of the storage account"
  type        = string
  validation {
    condition     = contains(["Storage", "StorageV2", "BlobStorage", "BlockBlobStorage", "FileStorage"], var.storage_account_kind)
    error_message = "The account kind of the storage account is invalid."
  }
}
variable "storage_access_tier" {
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts."
  type        = string
  validation {
    condition     = contains(["Hot", "Cool"], var.storage_access_tier)
    error_message = "The access tier of the storage account is invalid."
  }
}
variable "storage_account_tier" {
  description = "Specifies the account tier of the storage account"
  type        = string
  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "The account tier of the storage account is invalid."
  }
}
variable "storage_replication_type" {
  description = "Specifies the replication type of the storage account"
  type        = string
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_replication_type)
    error_message = "The replication type of the storage account is invalid."
  }
}

variable "storage_default_action" {
  description = "Allow or disallow public access to all blobs or containers in the storage accounts."
  type        = string
}

variable "storage_allow_blob_public_access" {
  description = "Allow nested items (blobs) to be publicly accessible. Should be false for security."
  type        = bool
  default     = false
}

variable "storage_container_name" {
  description = "The name of the Container within the Blob Storage Account where Kafka messages should be captured."
  type        = string
}
variable "storage_file_share_name" {
  description = "The name of the File Share within the Storage Account where files should be stored."
  type        = string
}

variable "storage_file_share_quota" {
  description = "The maximum size of the file share, in gigabytes."
  type        = number
}

variable "storage_container_access_type" {
  description = "The Access Level configured for this Container. Valid options are blob, container or private."
  type        = string
  validation {
    condition     = contains(["blob", "container", "private"], var.storage_container_access_type)
    error_message = "storage_container_access_type must be blob, container, or private."
  }
}

// ========================== log analytics variables ==========================
variable "log_analytics_workspace_sku" {
  description = "Specifies the SKU of the log analytics workspace."
  type        = string
  validation {
    condition     = contains(["Free", "Standalone", "PerNode", "PerGB2018"], var.log_analytics_workspace_sku)
    error_message = "The log analytics SKU is incorrect."
  }
}

variable "log_analytics_workspaces" {
  description = "A map of workspaces and their associated solutions."
  type = map(object({
    retention_days = number
    solution_name  = string
    solution_plan_map = map(object({
      product   = string
      publisher = string
    }))
  }))
}

variable "log_analytics" {
  description = "Map of log analytics per resource group to create."
  type        = map(string)
}

// ========================== log analytics variables for AKS ==========================
variable "aks_log_data_collection_interval" {
  type        = string
  description = "Log data collection interval for AKS."
  default     = "1m"
}

variable "aks_log_namespace_filtering_mode_for_data_collection" {
  type        = string
  description = "Log namespace filtering mode for data collection in AKS."
  default     = "Off"
}

variable "aks_log_namespaces_for_data_collection" {
  type        = list(string)
  description = "Namespaces for log data collection in AKS."
  default     = ["kube-system", "gatekeeper-system", "azure-arc"]
}

variable "aks_log_enableContainerLogV2" {
  type        = bool
  description = "Enable Container Log V2 for AKS."
  default     = true
}

variable "aks_log_streams" {
  type        = list(string)
  description = "Log streams for AKS."
  default     = ["Microsoft-ContainerLog", "Microsoft-ContainerLogV2", "Microsoft-KubeEvents", "Microsoft-KubePodInventory", "Microsoft-KubeNodeInventory", "Microsoft-KubePVInventory", "Microsoft-KubeServices", "Microsoft-KubeMonAgentEvents", "Microsoft-InsightsMetrics", "Microsoft-ContainerInventory", "Microsoft-ContainerNodeInventory", "Microsoft-Perf"]
}

variable "acr_sku" {
  type        = string
  description = "ACR SKU for the container registry: Basic, Standard, or Premium"
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "ACR SKU must be Basic, Standard, or Premium."
  }
}

// ========================== AKS upgrade variables ==========================
variable "aks_automatic_upgrade_channel" {
  type        = string
  description = "AKS auto-upgrade channel: none, patch, rapid, stable, or node-image"
  default     = "patch"
  validation {
    condition     = contains(["none", "patch", "rapid", "stable", "node-image"], var.aks_automatic_upgrade_channel)
    error_message = "aks_automatic_upgrade_channel must be none, patch, rapid, stable, or node-image."
  }
}

variable "aks_node_os_upgrade_channel" {
  type        = string
  description = "Node OS upgrade channel: None, Unmanaged, NodeImage, or SecurityPatch"
  default     = "SecurityPatch"
  validation {
    condition     = contains(["None", "Unmanaged", "NodeImage", "SecurityPatch"], var.aks_node_os_upgrade_channel)
    error_message = "aks_node_os_upgrade_channel must be None, Unmanaged, NodeImage, or SecurityPatch."
  }
}

variable "aks_image_cleaner_enabled" {
  type        = bool
  description = "Enable image cleaner to remove unused container images from nodes"
  default     = true
}

variable "aks_image_cleaner_interval_hours" {
  type        = number
  description = "Interval in hours between image cleaner runs (1–≥168)"
  default     = 48
}

variable "istio_revision" {
  type        = string
  description = "Istio revision to deploy via the AKS managed add-on (e.g. asm-1-28)"
  default     = "asm-1-28"
}

variable "akv2k8s_chart_version" {
  type        = string
  description = "Helm chart version for akv2k8s (Azure Key Vault to Kubernetes)"
  default     = "2.5.3"
}

