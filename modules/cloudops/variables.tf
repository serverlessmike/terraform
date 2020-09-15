variable "project_name" {
  type        = "string"
  description = "name of our project"
  default     = "cloudops"
}

variable "environment" {
  type        = "string"
  description = "environment"
}

variable "module_instance_id" {
  type        = "string"
  description = "Use this to create unique resource names"
  default     = "0"
}

variable "private_subnets" {
  type        = "list"
  description = "private subnet cidrs"
}

variable "public_subnets" {
  type        = "list"
  description = "public subnet cidrs"
}

variable "vpc_cidr" {
  type        = "string"
  description = "describe your variable"
}

variable "enable_vpn" {
  description = "True/False value for enabling VPN gateway to VPC"
  default     = false
}

variable "propagate_private_route_tables_vgw" {
  description = "True/False value for propagating private route tables with vgw routes"
  default     = true
}

variable "vpc_tgw_subnets" {
  type        = "list"
  description = "Subnets for transit gateway connectivity"
}
