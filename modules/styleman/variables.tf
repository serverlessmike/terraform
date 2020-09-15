variable "project_name" {}

variable "environment" {}

variable "vpc_id" {}

variable "private_subnets" {
  type = "list"
}

variable "sns_encrypted_slack_webhook_url" {}

variable "vpn_connection_id" {}

variable "policy" {
  description = "(Required) The policy document. This is a JSON formatted string"
}

variable "wms_elb_name" {}
