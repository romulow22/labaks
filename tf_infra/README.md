<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.7.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | ./modules/aks | n/a |
| <a name="module_eventhub_namespace"></a> [eventhub\_namespace](#module\_eventhub\_namespace) | ./modules/eventhubnamespace | n/a |
| <a name="module_eventhub_topics"></a> [eventhub\_topics](#module\_eventhub\_topics) | ./modules/eventhub | n/a |
| <a name="module_loganalytics"></a> [loganalytics](#module\_loganalytics) | ./modules/loganalytics | n/a |
| <a name="module_redis"></a> [redis](#module\_redis) | ./modules/redis | n/a |
| <a name="module_rg"></a> [rg](#module\_rg) | ./modules/resourcegroup | n/a |
| <a name="module_storageaccount"></a> [storageaccount](#module\_storageaccount) | ./modules/storageaccount | n/a |
| <a name="module_subnetaks"></a> [subnetaks](#module\_subnetaks) | ./modules/subnet | n/a |
| <a name="module_subnetpvt"></a> [subnetpvt](#module\_subnetpvt) | ./modules/subnet | n/a |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | ./modules/vnet | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_dns_service_ip"></a> [aks\_dns\_service\_ip](#input\_aks\_dns\_service\_ip) | AKS DNS Service IP | `string` | n/a | yes |
| <a name="input_aks_log_data_collection_interval"></a> [aks\_log\_data\_collection\_interval](#input\_aks\_log\_data\_collection\_interval) | Log data collection interval for AKS. | `string` | `"1m"` | no |
| <a name="input_aks_log_enableContainerLogV2"></a> [aks\_log\_enableContainerLogV2](#input\_aks\_log\_enableContainerLogV2) | Enable Container Log V2 for AKS. | `bool` | `true` | no |
| <a name="input_aks_log_namespace_filtering_mode_for_data_collection"></a> [aks\_log\_namespace\_filtering\_mode\_for\_data\_collection](#input\_aks\_log\_namespace\_filtering\_mode\_for\_data\_collection) | Log namespace filtering mode for data collection in AKS. | `string` | `"Off"` | no |
| <a name="input_aks_log_namespaces_for_data_collection"></a> [aks\_log\_namespaces\_for\_data\_collection](#input\_aks\_log\_namespaces\_for\_data\_collection) | Namespaces for log data collection in AKS. | `list(string)` | <pre>[<br>  "kube-system",<br>  "gatekeeper-system",<br>  "azure-arc"<br>]</pre> | no |
| <a name="input_aks_log_streams"></a> [aks\_log\_streams](#input\_aks\_log\_streams) | Log streams for AKS. | `list(string)` | <pre>[<br>  "Microsoft-ContainerLog",<br>  "Microsoft-ContainerLogV2",<br>  "Microsoft-KubeEvents",<br>  "Microsoft-KubePodInventory",<br>  "Microsoft-KubeNodeInventory",<br>  "Microsoft-KubePVInventory",<br>  "Microsoft-KubeServices",<br>  "Microsoft-KubeMonAgentEvents",<br>  "Microsoft-InsightsMetrics",<br>  "Microsoft-ContainerInventory",<br>  "Microsoft-ContainerNodeInventory",<br>  "Microsoft-Perf"<br>]</pre> | no |
| <a name="input_aks_max_node_count"></a> [aks\_max\_node\_count](#input\_aks\_max\_node\_count) | Maximum node count for worker node | `number` | n/a | yes |
| <a name="input_aks_min_node_count"></a> [aks\_min\_node\_count](#input\_aks\_min\_node\_count) | Minimum node count for worker node | `number` | n/a | yes |
| <a name="input_aks_node_vm_size"></a> [aks\_node\_vm\_size](#input\_aks\_node\_vm\_size) | Size of worker node | `string` | n/a | yes |
| <a name="input_aks_service_cidr"></a> [aks\_service\_cidr](#input\_aks\_service\_cidr) | AKS Service CIDRs | `string` | n/a | yes |
| <a name="input_aks_subnet"></a> [aks\_subnet](#input\_aks\_subnet) | AKS Subnet CIDRs | `list(string)` | n/a | yes |
| <a name="input_aks_subnet_security_rules"></a> [aks\_subnet\_security\_rules](#input\_aks\_subnet\_security\_rules) | A list of security rules to be created. | <pre>list(object({<br>    name                          = string<br>    priority                      = number<br>    direction                     = string <br>    access                        = string<br>    protocol                      = string<br>    source_port_ranges            = list(string)<br>    destination_port_ranges       = list(string)<br>    source_address_prefixes       = list(string)<br>    destination_address_prefixes  = list(string)<br>    }))</pre> | n/a | yes |
| <a name="input_aks_version"></a> [aks\_version](#input\_aks\_version) | Version of the AKS | `string` | n/a | yes |
| <a name="input_enable_module_aks"></a> [enable\_module\_aks](#input\_enable\_module\_aks) | Flag to turn on or off the module | `bool` | `true` | no |
| <a name="input_enable_module_eventhub_namespace"></a> [enable\_module\_eventhub\_namespace](#input\_enable\_module\_eventhub\_namespace) | Flag to turn on or off the module | `bool` | `true` | no |
| <a name="input_enable_module_eventhub_topics"></a> [enable\_module\_eventhub\_topics](#input\_enable\_module\_eventhub\_topics) | Flag to turn on or off the module | `bool` | `true` | no |
| <a name="input_enable_module_loganalytics"></a> [enable\_module\_loganalytics](#input\_enable\_module\_loganalytics) | Flag to turn on or off the module | `bool` | `true` | no |
| <a name="input_enable_module_redis"></a> [enable\_module\_redis](#input\_enable\_module\_redis) | Flag to turn on or off the module | `bool` | `true` | no |
| <a name="input_enable_module_rg"></a> [enable\_module\_rg](#input\_enable\_module\_rg) | Flag to turn on or off the module | `bool` | `true` | no |
| <a name="input_enable_module_storageaccount"></a> [enable\_module\_storageaccount](#input\_enable\_module\_storageaccount) | Flag to turn on or off the module | `bool` | `true` | no |
| <a name="input_enable_module_subnetaks"></a> [enable\_module\_subnetaks](#input\_enable\_module\_subnetaks) | Flag to turn on or off the module | `bool` | `true` | no |
| <a name="input_enable_module_subnetpvt"></a> [enable\_module\_subnetpvt](#input\_enable\_module\_subnetpvt) | Flag to turn on or off the module | `bool` | `true` | no |
| <a name="input_enable_module_vnet"></a> [enable\_module\_vnet](#input\_enable\_module\_vnet) | Flag to turn on or off the module | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_kafka_eh_capacity"></a> [kafka\_eh\_capacity](#input\_kafka\_eh\_capacity) | Specifies the Capacity / Throughput Units for a Standard SKU namespace. | `number` | n/a | yes |
| <a name="input_kafka_eh_message_retention"></a> [kafka\_eh\_message\_retention](#input\_kafka\_eh\_message\_retention) | Specifies the number of days to retain messages. | `number` | n/a | yes |
| <a name="input_kafka_eh_partition_count"></a> [kafka\_eh\_partition\_count](#input\_kafka\_eh\_partition\_count) | Specifies the number of partitions for a Kafka topic. | `number` | n/a | yes |
| <a name="input_kafka_eh_sku"></a> [kafka\_eh\_sku](#input\_kafka\_eh\_sku) | Defines which tier to use for the Event Hub. | `string` | n/a | yes |
| <a name="input_kafka_eh_topics"></a> [kafka\_eh\_topics](#input\_kafka\_eh\_topics) | An array of strings that indicates values of Kafka topics. | `list(string)` | n/a | yes |
| <a name="input_log_analytics"></a> [log\_analytics](#input\_log\_analytics) | Map of log analytics per resource group to create. | `map(string)` | n/a | yes |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | Specifies the SKU of the log analytics workspace. | `string` | n/a | yes |
| <a name="input_log_anatytics_workspaces"></a> [log\_anatytics\_workspaces](#input\_log\_anatytics\_workspaces) | A map of workspaces and their associated solutions. | <pre>map(object({<br>    retention_days    = number<br>    solution_name     = string<br>    solution_plan_map = map(object({<br>      product   = string<br>      publisher = string<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_pvt_subnet"></a> [pvt\_subnet](#input\_pvt\_subnet) | Private Subnet CIDRs | `list(string)` | n/a | yes |
| <a name="input_pvt_subnet_security_rules"></a> [pvt\_subnet\_security\_rules](#input\_pvt\_subnet\_security\_rules) | A list of security rules to be created. | <pre>list(object({<br>    name                          = string<br>    priority                      = number<br>    direction                     = string <br>    access                        = string<br>    protocol                      = string<br>    source_port_ranges            = list(string)<br>    destination_port_ranges       = list(string)<br>    source_address_prefixes       = list(string)<br>    destination_address_prefixes  = list(string)<br>    }))</pre> | n/a | yes |
| <a name="input_redis_capacity"></a> [redis\_capacity](#input\_redis\_capacity) | The size of the Redis cache | `number` | n/a | yes |
| <a name="input_redis_enable_authentication"></a> [redis\_enable\_authentication](#input\_redis\_enable\_authentication) | If set to false, the Redis instance will be accessible without authentication. | `bool` | n/a | yes |
| <a name="input_redis_enable_non_ssl_port"></a> [redis\_enable\_non\_ssl\_port](#input\_redis\_enable\_non\_ssl\_port) | Specifies whether the non-ssl Redis server port (6379) is enabled | `bool` | n/a | yes |
| <a name="input_redis_family"></a> [redis\_family](#input\_redis\_family) | The family of the SKU to use | `string` | n/a | yes |
| <a name="input_redis_maxmemory_policy"></a> [redis\_maxmemory\_policy](#input\_redis\_maxmemory\_policy) | The eviction policy for the Redis cache | `string` | n/a | yes |
| <a name="input_redis_public_network_access"></a> [redis\_public\_network\_access](#input\_redis\_public\_network\_access) | Whether or not public network access is allowed for this Redis Cache. | `bool` | n/a | yes |
| <a name="input_redis_sku_name"></a> [redis\_sku\_name](#input\_redis\_sku\_name) | The SKU of Redis cache to use | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region | `string` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | Map of resource groups to create | `map(string)` | n/a | yes |
| <a name="input_storage_access_tier"></a> [storage\_access\_tier](#input\_storage\_access\_tier) | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. | `string` | n/a | yes |
| <a name="input_storage_account_kind"></a> [storage\_account\_kind](#input\_storage\_account\_kind) | Specifies the account kind of the storage account | `string` | n/a | yes |
| <a name="input_storage_account_tier"></a> [storage\_account\_tier](#input\_storage\_account\_tier) | Specifies the account tier of the storage account | `string` | n/a | yes |
| <a name="input_storage_allow_blob_public_access"></a> [storage\_allow\_blob\_public\_access](#input\_storage\_allow\_blob\_public\_access) | Specifies the public access type for blob storage | `bool` | n/a | yes |
| <a name="input_storage_container_access_type"></a> [storage\_container\_access\_type](#input\_storage\_container\_access\_type) | The Access Level configured for this Container. | `string` | n/a | yes |
| <a name="input_storage_container_name"></a> [storage\_container\_name](#input\_storage\_container\_name) | The name of the Container within the Blob Storage Account where Kafka messages should be captured. | `string` | n/a | yes |
| <a name="input_storage_default_action"></a> [storage\_default\_action](#input\_storage\_default\_action) | Allow or disallow public access to all blobs or containers in the storage accounts. | `string` | n/a | yes |
| <a name="input_storage_file_share_name"></a> [storage\_file\_share\_name](#input\_storage\_file\_share\_name) | The name of the File Share within the Storage Account where files should be stored. | `string` | n/a | yes |
| <a name="input_storage_file_share_quota"></a> [storage\_file\_share\_quota](#input\_storage\_file\_share\_quota) | The maximum size of the file share, in gigabytes. | `number` | n/a | yes |
| <a name="input_storage_replication_type"></a> [storage\_replication\_type](#input\_storage\_replication\_type) | Specifies the replication type of the storage account | `string` | n/a | yes |
| <a name="input_vnet"></a> [vnet](#input\_vnet) | Virtual Network CIDR | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->