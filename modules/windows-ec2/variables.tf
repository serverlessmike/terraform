variable "environment" {
  description = "Environment in which to build"
  type        = "string"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = "string"
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = "string"
}

variable "is_public" {
  description = "boolean to show if the server is publicly accessible"
  type        = "string"
  default     = false
}

variable "product" {
  description = "Names of product"
  type        = "string"
}

variable "ami_version" {
  description = "Version of Windows Server required"
  type        = "string"
}

variable "os_version" {
  description = "Version of Windows Server required (2016 or 2019)"
  default     = "2019"
  type        = "string"
}

variable "owner" {
  description = "Owner of server being started"
  type        = "string"
}

variable "instance_type" {
  description = "instance type to be started"
  type        = "string"
}

variable "min_size" {
  description = "The minimum size of the auto scale group"
  type        = "string"
  default     = "1"
}

variable "des_size" {
  description = "The number of instances that should be running in the auto scale group"
  type        = "string"
  default     = "1"
}

variable "max_size" {
  description = "The maximum size of the auto scale group"
  default     = "1"
  type        = "string"
}

variable "customisation_script" {
  description = "Names of the customisation scripts to run"
  type        = "string"
}

variable "backup_interval" {
  description = "Number of hours between backups"
  type        = "string"
  default     = "24"
}

variable "backups_retained" {
  description = "Number of backups of a volume to keep"
  type        = "string"
  default     = "0"
}

variable "backup_start_time" {
  description = "Start time in hh:mm format for backups"
  type        = "string"
  default     = "00:00"
}

variable "tcp_in" {
  description = "List of TCPs port to open inbound"
  type        = "list"
  default     = []
}

variable "udp_in" {
  description = "List of UDPs port to open inbound"
  type        = "list"
  default     = []
}

variable "tcp_out" {
  description = "List of TCPs port to open outbound"
  type        = "list"
  default     = []
}

variable "udp_out" {
  description = "List of UDPs port to open outbound"
  type        = "list"
  default     = []
}

variable "d_volume" {
  description = "Unformatted size in GB of D volume"
  type        = "string"
  default     = ""
}

variable "e_volume" {
  description = "Unformatted size in GB of E volume"
  type        = "string"
  default     = ""
}

variable "f_volume" {
  description = "Unformatted size in GB of F volume"
  type        = "string"
  default     = ""
}

variable "zone_id" {
  description = "Route 53 zone in which to build"
  type        = "string"
}

variable "topic_arn" {
  description = "Topic to send Windows events to"
  type        = "string"
}
