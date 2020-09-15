# DEPRECATED

Please do *NOT* use this module to create any new resources. It has been completely replaced by [this](https://github.com/River-Island/cloudops-terraform/tree/master/modules/windows-ec2).



## stateful-ec2 Module

Module to create a series of stateful EC2 instances inside ASGs

## Environment Level Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|-------|-------|
| environment | Environment in which to build | string | - | yes |
| private_subnet_ids | Private subnet IDs | string | - | yes |
| public_subnet_ids | Public subnet IDs | string | - | yes |

## Product Level Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|-------|-------|
| is_public | List of booleans to indicate if the servers are publicly accessible | list | - | yes |
| products | Names of products | list | - | yes |
| ami_versions | Version of Windows Server 2019 required by each product | list | - | yes |
| owners | Owners of each server being started | list | - | yes |
| instance_types | instance type to be started | list | - | yes |
| min_size | The minimum size of the auto scale group | list | - | yes |
| des_size | The number of Amazon EC2 instances that should be running in the group | list | - | yes |
| max_size | The maximum size of the auto scale group | list | - | yes |
| customisation_scripts | Names of the customisation scripts to run | list | - | yes |
| backup_intervals | Number of hours between backups | list | - | yes |
| backups_retained | Number of backups of a volume to keep | list | - | yes |
| backups_start_times | Start time in hh:mm format for backups | list | - | yes |
| allow_1433_in | List of products that allow 1433 TCP (SQL Server) inbound | list | - | yes |
| allow_1434_in | List of products that allow 1434 TCP (SQL Server) inbound | list | - | yes |
| allow_rdp_in | List of products that allow RDP inbound | list | - | yes |
| allow_ssh_in | List of products that allow SSH inbound | list | - | yes |


## Outputs

| Name | Description |
|------|-------------|
| stateful_asg_ids | The auto scale group IDs |
| stateful_asg_arns | The ARNs for the groups |

## Notes
Please note that the instances are created with a root volume only. In order to add extra volumes, please use the external "ebs" module.

