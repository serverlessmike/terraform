# MobileIron/Connector

Creates and maintains the MobileIron Connector AWS resources for the Device Modernisation project.

Currently this module will create an ASG based off a private Mobile Connector AMI (Created manually post manual configuration - Vendor restictions!) and a R53 record for the NLB.

[Vendor Documentation](http://mi.extendedhelp.mobileiron.com/40/all/en/desktop/Connector.htm)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ami_account_id | Mobile Iron AWS Account ID that owns the Sentry AMI | string | `795357751823` | no |
| connector_version | Mobile Iron Connector Version | string | - | yes |
| environment | Envrionemnt to be deployed | string | - | yes |
| private_subnets | private subnets for ECS cluster nodes | list | - | yes |
| product_name | Product name | string | `connector` | no |
| project_name | Name of the project | string | `Device Modernisation` | no |
| project_name_tag | Tag friendly project name | string | `device-modernisation` | no |
| public_subnets | public subnets for ECS cluster nodes | list | - | yes |
| r53_zone_id | Route53 zone for LB record. Must end as with . | string | - | yes |
| security_groups | List of security group IDs to be attached to the launch configuration | list | - | yes |
| ssh_key_name | SSH Keypair name | string | - | yes |
| tags | A list of tag blocks. Each element should have keys named key, value, and propagate_at_launch. | string | `<list>` | no |
| tags_as_map | A map of tags and values in the same format as other resources accept. This will be converted into the non-standard format that the aws_autoscaling_group requires. | map | `<map>` | no |
| vpc_id | VPC ID | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| connector_instance_dns | Sentry LB DNS record |