<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.diag_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_role_assignment.storage_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_share.storage_share](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot. | `string` | n/a | yes |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | (Optional) Specifies the account kind of the storage account | `string` | n/a | yes |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | Specifies the account tier of the storage account | `string` | n/a | yes |
| <a name="input_aks_identity_principal_id"></a> [aks\_identity\_principal\_id](#input\_aks\_identity\_principal\_id) | aks\_identity\_principal\_id | `string` | n/a | yes |
| <a name="input_allow_blob_public_access"></a> [allow\_blob\_public\_access](#input\_allow\_blob\_public\_access) | Specifies the public access type for blob storage | `bool` | n/a | yes |
| <a name="input_container_access_type"></a> [container\_access\_type](#input\_container\_access\_type) | (Optional) The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private. | `string` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | (Required) The name of the Container within the Blob Storage Account where kafka messages should be captured | `string` | n/a | yes |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | Allow or disallow public access to all blobs or containers in the storage accounts. The default interpretation is true for this property. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_file_share_name"></a> [file\_share\_name](#input\_file\_share\_name) | (Required) The name of the File Share within the Storage Account where Files should be stored | `string` | n/a | yes |
| <a name="input_file_share_quota"></a> [file\_share\_quota](#input\_file\_share\_quota) | (Required) The maximum size of the share, in gigabytes. | `number` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location for the Event Hub | `string` | n/a | yes |
| <a name="input_proj_name"></a> [proj\_name](#input\_proj\_name) | Project name | `string` | n/a | yes |
| <a name="input_replication_type"></a> [replication\_type](#input\_replication\_type) | Specifies the replication type of the storage account | `string` | n/a | yes |
| <a name="input_rg_id"></a> [rg\_id](#input\_rg\_id) | resource group id | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_storage_kind"></a> [storage\_kind](#input\_storage\_kind) | (Optional) Specifies the kind of the storage account | `string` | `""` | no |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | workspace\_id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_storage_account_conn_string"></a> [storage\_account\_conn\_string](#output\_storage\_account\_conn\_string) | Connection String of the Storage Account |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | ID of the Storage Account |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | Name of the Storage Account |
| <a name="output_storage_container_id"></a> [storage\_container\_id](#output\_storage\_container\_id) | ID of the Storage Container |
| <a name="output_storage_container_name"></a> [storage\_container\_name](#output\_storage\_container\_name) | Name of the Storage Container |
| <a name="output_storage_logdiagnostics_id"></a> [storage\_logdiagnostics\_id](#output\_storage\_logdiagnostics\_id) | n/a |
| <a name="output_storage_logdiagnostics_name"></a> [storage\_logdiagnostics\_name](#output\_storage\_logdiagnostics\_name) | n/a |
| <a name="output_storage_share_id"></a> [storage\_share\_id](#output\_storage\_share\_id) | ID of the Storage Share |
| <a name="output_storage_share_name"></a> [storage\_share\_name](#output\_storage\_share\_name) | Name of the Storage Share |
| <a name="output_storage_share_url"></a> [storage\_share\_url](#output\_storage\_share\_url) | URL of the Storage Share |
<!-- END_TF_DOCS -->