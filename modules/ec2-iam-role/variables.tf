variable "name" {
  description = "The name of the IAM Role."
}

variable "path" {
  description = "The path to the IAM Role."
  default     = "/"
}

variable "description" {
  description = "The description of the IAM Role."
  default     = "This IAM Role generated by Terraform."
}

variable "force_detach_policies" {
  description = "Forcibly detach the policy of the role."
  default     = false
}

variable "policy" {
  description = "Attach the policy to the IAM Role."
  type        = "string"
}

variable "environment" {}
