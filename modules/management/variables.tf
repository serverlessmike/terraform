variable "project_name" {
  type        = "string"
  description = "name of our project"
  default     = "cloudops"
}

variable "environment" {
  type        = "string"
  description = "environment"
  default     = "management"
}

variable "module_instance_id" {
  type        = "string"
  description = "Use this to create unique resource names"
  default     = "0"
}

variable "private_subnets" {
  type        = "list"
  description = "private subnet cidrs"
  default     = ["10.202.168.0/24", "10.202.169.0/24", "10.202.170.0/24"]
}

variable "public_subnets" {
  type        = "list"
  description = "public subnet cidrs"
  default     = ["10.202.171.0/24", "10.202.172.0/24", "10.202.173.0/24"]
}

variable "vpc_cidr" {
  type        = "string"
  description = "describe your variable"
  default     = "10.202.168.0/21"
}

variable "aws_ssh_key_file" {
  type        = "string"
  description = "name of the ssh key file stored in the aws account folder"
  default     = "default"
}

// Transit Peering
# variable "dev_transit_vpc_account_id" {
#   type        = "string"
#   description = "the id of the account that the transit vpc sits in"
#   default     = "556748783639"
# }

# variable "dev_transit_vpc_id" {
#   type        = "string"
#   description = "the id of the transit vpc that has the direct connect connection attached"
#   default     = "vpc-2ee35b4a"
# }

# variable "dev_transit_vpc_subnet_cidr" {
#   type        = "string"
#   description = "CIDR of vpc subnet to route to"
#   default     = "10.201.0.0/16"
# }

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
