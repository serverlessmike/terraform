// Global Variables
variable "environment" {
  description = "Envrionemnt to be deployed"
}

variable "project_name" {
  description = "Name of the project"
  default     = "cloudops"
}

// Variables for main.tf
variable "cgw_ip" {
  description = "Customer Gateway IP Address"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "private_route_table_ids" {
  type = "list"
}

variable "vpn_vgw_id" {
  description = "VPN Gateway ID"
}
