# MobileIron

Creates and maintains the MobileIron AWS resources for the Device Modernisation project.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ami_account_id | Mobile Iron AWS Account ID that owns the Sentry AMI | string | `795357751823` | no |
| connector_version | Mobile Iron Connector Version | string | - | yes |
| environment | Envrionemnt to be deployed | string | - | yes |
| private_subnets | private subnets for ECS cluster nodes | list | - | yes |
| project_name | Name of the project | string | `Device Modernisation` | no |
| project_name_tag | Tag friendly project name | string | `device-modernisation` | no |
| public_subnets | public subnets for ECS cluster nodes | list | - | yes |
| r53_zone_id | Route53 zone for LB record. Must end as with . | string | - | yes |
| sentry_version | Mobile Iron Sentry Version | string | - | yes |
| ssh_key_name | SSH Keypair name | string | - | yes |
| tags | A list of tag blocks. Each element should have keys named key, value, and propagate_at_launch. | string | `<list>` | no |
| tags_as_map | A map of tags and values in the same format as other resources accept. This will be converted into the non-standard format that the aws_autoscaling_group requires. | map | `<map>` | no |
| vpc_id | VPC ID | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| connector_dns | Connector DNS record |
| sentry_dns | Sentry LB DNS record |
