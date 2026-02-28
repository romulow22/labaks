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
| [azurerm_log_analytics_solution.solution](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location for the Event Hub | `string` | n/a | yes |
| <a name="input_proj_name"></a> [proj\_name](#input\_proj\_name) | Project name | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_workspace_sku"></a> [workspace\_sku](#input\_workspace\_sku) | (Optional) Specifies the sku of the log analytics workspace | `string` | n/a | yes |
| <a name="input_workspaces"></a> [workspaces](#input\_workspaces) | A map of workspaces and their associated solutions | <pre>map(object({<br>    retention_days    = number<br>    solution_name = string<br>    solution_plan_map = map(object({<br>      product   = string<br>      publisher = string<br>    }))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The ID of the Log Analytics Workspace. |
| <a name="output_log_analytics_workspace_location"></a> [log\_analytics\_workspace\_location](#output\_log\_analytics\_workspace\_location) | Specifies the location of the log analytics workspace |
| <a name="output_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#output\_log\_analytics\_workspace\_name) | Specifies the name of the log analytics workspace |
| <a name="output_log_analytics_workspace_primary_shared_key"></a> [log\_analytics\_workspace\_primary\_shared\_key](#output\_log\_analytics\_workspace\_primary\_shared\_key) | Specifies the workspace key of the log analytics workspace |
| <a name="output_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#output\_log\_analytics\_workspace\_resource\_group\_name) | Specifies the name of the resource group that contains the log analytics workspace |
| <a name="output_log_analytics_workspace_workspace_id"></a> [log\_analytics\_workspace\_workspace\_id](#output\_log\_analytics\_workspace\_workspace\_id) | Specifies the workspace id of the log analytics workspace |
<!-- END_TF_DOCS -->