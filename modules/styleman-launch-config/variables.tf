variable "key_name" {}

variable "environment" {}

variable "private_subnets" {
  type = "list"
}

variable "cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  default     = true
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle"
  default     = 60
}

variable "connection_draining" {
  description = "Boolean to enable connection draining"
  default     = true
}

variable "connection_draining_timeout" {
  description = "The time in seconds to allow for connections to drain"
  default     = 300
}

variable "listener" {
  description = "A list of listener blocks"
  type        = "list"
}

//# autoscaling
//# asg
variable "max_size" {
  default     = 1
  description = "The maximum size of the auto scale group"
}

variable "min_size" {
  default     = 1
  description = "The minimum size of the auto scale group"
}

variable "desired_capacity" {
  default     = 1
  description = "The number of Amazon EC2 instances that should be running in the group"
}

variable "min_elb_capacity" {
  default     = 1
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
}

variable "health_check_type" {
  default     = "EC2"
  description = "Controls how health checking is done. Values are - EC2 and ELB"
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default"
  type        = "list"
  default     = ["OldestLaunchConfiguration"]
}

variable "access_logs" {
  description = "An access logs block"
  type        = "list"
  default     = []
}

variable "health_check" {
  description = "A health check block"
  type        = "list"
}

variable "ami_id" {}

variable "instance_type" {}

variable "iam_role_profile_name" {}

variable "elb_sg" {
  type = "list"
}

variable "asg_sg" {
  type = "list"
}

variable "project_name" {}
