// Global Variables
variable "environment" {
  description = "Envrionemnt to be deployed"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "project_name" {
  description = "Name of the project"
  default     = "Device Modernisation"
}

variable "project_name_tag" {
  description = "Tag friendly project name"
  default     = "device-modernisation"
}

variable "product_name" {
  description = "Product name"
  default     = "connector"
}

variable "ssh_key_name" {
  description = "SSH Keypair name"
}

variable "private_subnets" {
  description = "private subnets for ECS cluster nodes"
  type        = "list"
}

variable "public_subnets" {
  description = "public subnets for ECS cluster nodes"
  type        = "list"
}

// asg.tf variables
variable "ami_account_id" {
  description = "Mobile Iron AWS Account ID that owns the Sentry AMI"
  default     = "795357751823"
}

variable "tags_as_map" {
  description = "A map of tags and values in the same format as other resources accept. This will be converted into the non-standard format that the aws_autoscaling_group requires."
  type        = "map"
  default     = {}
}

locals {
  tags_asg_format = ["${null_resource.tags_as_list_of_maps.*.triggers}"]
}

resource "null_resource" "tags_as_list_of_maps" {
  count = "${length(keys(var.tags_as_map))}"

  triggers = "${map(
    "key", "${element(keys(var.tags_as_map), count.index)}",
    "value", "${element(values(var.tags_as_map), count.index)}",
    "propagate_at_launch", "true"
  )}"
}

variable "tags" {
  description = "A list of tag blocks. Each element should have keys named key, value, and propagate_at_launch."
  default     = []
}

variable "security_groups" {
  description = "List of security group IDs to be attached to the launch configuration"
  type        = "list"
}

variable "connector_ami" {
  description = "Connector AMI shared by MobileIron"
  default     = "ami-c8d9d222"
}

// route_53.tf variables

variable "r53_zone_id" {
  description = "Route53 zone for LB record. Must end as with ."
}
