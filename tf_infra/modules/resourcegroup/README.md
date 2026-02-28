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
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the resources | `string` | n/a | yes |
| <a name="input_proj_name"></a> [proj\_name](#input\_proj\_name) | project Name | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the services | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rg_id"></a> [rg\_id](#output\_rg\_id) | Resource group id |
| <a name="output_rg_name"></a> [rg\_name](#output\_rg\_name) | Resource group name |
<!-- END_TF_DOCS -->