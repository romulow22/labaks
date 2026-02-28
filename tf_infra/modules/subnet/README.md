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
| [azurerm_network_security_group.public_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsg_associate_public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | environment | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | location of the resources | `string` | n/a | yes |
| <a name="input_proj_name"></a> [proj\_name](#input\_proj\_name) | project Name | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | rg Name | `string` | n/a | yes |
| <a name="input_security_rules"></a> [security\_rules](#input\_security\_rules) | A list of security rules to be created. | <pre>list(object({<br>    name                          = string<br>    priority                      = number<br>    direction                     = string <br>    access                        = string<br>    protocol                      = string<br>    source_port_ranges            = list(string)<br>    destination_port_ranges       = list(string)<br>    source_address_prefixes       = list(string)<br>    destination_address_prefixes  = list(string)<br>    }))</pre> | n/a | yes |
| <a name="input_subnet_address_prefix"></a> [subnet\_address\_prefix](#input\_subnet\_address\_prefix) | CIDR of subnet | `list(string)` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | subnet\_name | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | vnet Name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsgID"></a> [nsgID](#output\_nsgID) | ID of the nsg |
| <a name="output_public_subnet_id"></a> [public\_subnet\_id](#output\_public\_subnet\_id) | Public Subnet ID |
| <a name="output_public_subnet_name"></a> [public\_subnet\_name](#output\_public\_subnet\_name) | ID of virtual network |
<!-- END_TF_DOCS -->