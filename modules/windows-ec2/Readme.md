# Windows-ec2 Module

Module to create a series of stateful Windows EC2 instances inside ASGs

## Environment Level Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|-------|-------|
| environment | Environment in which to build | string | - | yes |
| private_subnet_ids | Private subnet IDs | string | - | yes |
| public_subnet_ids | Public subnet IDs | string | - | yes |
| zone_id | Route 53 zone in which to build | string | - | yes |
| topic_arn | Topic to send Windows events to | string | - | yes |

## Product Level Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|-------|-------|
| is_public | booleans to indicate if the servers are publicly accessible | string | false | no |
| product | Name of product | string | - | yes |
| ami_version | Version of Windows Server required | string | - | yes |
| os_version | Version of Windows Server required (2016 or 2019) | string | 2019 | no |
| owner | Owner of server being started | string | - | yes |
| instance_type | instance type to be started | string | - | yes |
| min_size | The minimum size of the auto scale group | string | 1 | no |
| des_size | The number of Amazon EC2 instances that should be running in the group | string | 1 | no |
| max_size | The maximum size of the auto scale group | string | 1 | no |
| customisation_script | Name of the customisation script to run | string | - | yes |
| backup_interval | Number of hours between backups | string | 24 | no |
| backups_retained | Number of backups of a volume to keep | string | 0 | no |
| backups_start_time | Start time in hh:mm format for backups | string | 00:00 | no |
| tcp_in | List of TCP ports open to inbound traffic | list | [] | no |
| udp_in | List of UDP ports open to inbound traffic | list | [] | no |
| tcp_out | List of TCP ports open to outbound traffic | list | [] | no |
| udp_out | List of UDP ports open to outbound traffic | list | [] | no |
| d_volume | Unformatted size in GB of D volume | string | "" | no |
| e_volume | Unformatted size in GB of E volume | string | "" | no |
| f_volume | Unformatted size in GB of F volume | string | "" | no |
| zone_id | Route 53 zone in which to build | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| None | n/a |

## Notes
Please note that the instances are created with a root volume only. In order to add extra volumes, please use the external "ebs" module.

