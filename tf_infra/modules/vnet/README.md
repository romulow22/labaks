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
| [azurerm_virtual_network.virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | CIDR of the vnet | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the resources | `string` | n/a | yes |
| <a name="input_proj_name"></a> [proj\_name](#input\_proj\_name) | project Name | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | resource group name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vnetID"></a> [vnetID](#output\_vnetID) | ID of virtual network |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | Vnet name |
<!-- END_TF_DOCS -->