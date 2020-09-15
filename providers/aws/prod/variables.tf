// vpc_peering - prod transit
variable "prod_transit_vpc_account_id" {
  type        = "string"
  description = "the id of the account that the transit vpc sits in"
  default     = "376076567968"
}

variable "prod_transit_vpc_id" {
  type        = "string"
  description = "the id of the transit vpc that has the direct connect connection attached"
  default     = "vpc-2efefe4a"
}

variable "prod_transit_vpc_subnet_cidr" {
  type        = "string"
  description = "CIDR of vpc subnet to route to"
  default     = "10.202.0.0/22"
}

variable "project_name" {
  type        = "string"
  description = "name of our project"
  default     = "cloudops"
}

variable "environment" {
  type        = "string"
  description = "environment"
  default     = "prod"
}

variable "private_subnets" {
  type        = "list"
  description = "private subnet cidrs"
  default     = ["10.202.177.0/24", "10.202.178.0/24", "10.202.179.0/24"]
}
