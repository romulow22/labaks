<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_kubernetes_cluster.aks-cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.wrk_nodepool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_monitor_data_collection_rule.dcr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) | resource |
| [azurerm_monitor_data_collection_rule_association.dcra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_role_assignment.cluster_admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_acr_pull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.aks_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [helm_release.nginx_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.kubeconfigyaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.public_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_kubernetes_service_versions.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_service_versions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | AKS version | `string` | n/a | yes |
| <a name="input_data_collection_interval"></a> [data\_collection\_interval](#input\_data\_collection\_interval) | n/a | `string` | `"1m"` | no |
| <a name="input_dns_service_ip"></a> [dns\_service\_ip](#input\_dns\_service\_ip) | Aks DNS Service Ip | `string` | n/a | yes |
| <a name="input_enableContainerLogV2"></a> [enableContainerLogV2](#input\_enableContainerLogV2) | n/a | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | environment | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | location of the resources | `string` | n/a | yes |
| <a name="input_max_count"></a> [max\_count](#input\_max\_count) | Maximum node count for worker node | `number` | n/a | yes |
| <a name="input_min_count"></a> [min\_count](#input\_min\_count) | Minimum node count for worker node | `number` | n/a | yes |
| <a name="input_namespace_filtering_mode_for_data_collection"></a> [namespace\_filtering\_mode\_for\_data\_collection](#input\_namespace\_filtering\_mode\_for\_data\_collection) | n/a | `string` | `"Off"` | no |
| <a name="input_namespaces_for_data_collection"></a> [namespaces\_for\_data\_collection](#input\_namespaces\_for\_data\_collection) | n/a | `list` | <pre>[<br>  "kube-system",<br>  "gatekeeper-system",<br>  "azure-arc"<br>]</pre> | no |
| <a name="input_node_vm_size"></a> [node\_vm\_size](#input\_node\_vm\_size) | Worker nodes size | `string` | n/a | yes |
| <a name="input_proj_name"></a> [proj\_name](#input\_proj\_name) | project Name | `string` | n/a | yes |
| <a name="input_rg_id"></a> [rg\_id](#input\_rg\_id) | resource group id | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | resource group name | `string` | n/a | yes |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | Aks Service CIDRs | `string` | n/a | yes |
| <a name="input_streams"></a> [streams](#input\_streams) | n/a | `list` | <pre>[<br>  "Microsoft-ContainerLog",<br>  "Microsoft-ContainerLogV2",<br>  "Microsoft-KubeEvents",<br>  "Microsoft-KubePodInventory",<br>  "Microsoft-KubeNodeInventory",<br>  "Microsoft-KubePVInventory",<br>  "Microsoft-KubeServices",<br>  "Microsoft-KubeMonAgentEvents",<br>  "Microsoft-InsightsMetrics",<br>  "Microsoft-ContainerInventory",<br>  "Microsoft-ContainerNodeInventory",<br>  "Microsoft-Perf"<br>]</pre> | no |
| <a name="input_subnetaks_id"></a> [subnetaks\_id](#input\_subnetaks\_id) | Subnet ID for worker node | `string` | n/a | yes |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | workspace\_id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | ACR ID |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
| <a name="output_kube_config_client_certificate"></a> [kube\_config\_client\_certificate](#output\_kube\_config\_client\_certificate) | n/a |
| <a name="output_kube_config_client_key"></a> [kube\_config\_client\_key](#output\_kube\_config\_client\_key) | n/a |
| <a name="output_kube_config_cluster_ca_certificate"></a> [kube\_config\_cluster\_ca\_certificate](#output\_kube\_config\_cluster\_ca\_certificate) | n/a |
| <a name="output_kube_config_host"></a> [kube\_config\_host](#output\_kube\_config\_host) | n/a |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | n/a |
| <a name="output_kubernetes_cluster_fqdn"></a> [kubernetes\_cluster\_fqdn](#output\_kubernetes\_cluster\_fqdn) | FQDN of nodes |
| <a name="output_kubernetes_cluster_id"></a> [kubernetes\_cluster\_id](#output\_kubernetes\_cluster\_id) | ID of the AKS Cluster |
| <a name="output_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#output\_kubernetes\_cluster\_name) | Name of the AKS Cluster |
| <a name="output_nginx_ingress_controller_status"></a> [nginx\_ingress\_controller\_status](#output\_nginx\_ingress\_controller\_status) | The external IP of the NGINX Ingress Controller |
| <a name="output_user_assigned_identity_client_id"></a> [user\_assigned\_identity\_client\_id](#output\_user\_assigned\_identity\_client\_id) | n/a |
| <a name="output_user_assigned_identity_principal_id"></a> [user\_assigned\_identity\_principal\_id](#output\_user\_assigned\_identity\_principal\_id) | n/a |
<!-- END_TF_DOCS -->