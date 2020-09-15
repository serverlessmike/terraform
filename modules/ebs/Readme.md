# ebs Module

This module creates EBS volumes and attaches them to a named instance

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|-------|-------|
| drives | List of drives names | list | - | yes |
| devices | List of device names | list | [xvdf, | no |
| product | Name of the product | string | - | yes |
| volume_sizes | List of volume sizes in GB | list | - | yes |
| environment | environment in which to build (dev,staging,prod) | string | - | yes |
| owner | Name of the owner of the volumes | string | - | yes |
| instance_id | ID of the pre-existing instance to attach to | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
