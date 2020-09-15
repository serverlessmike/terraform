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
  description = "List of booleans to show if the servers are publicly accessible"
  type        = "list"
}

variable "products" {
  description = "Names of products"
  type        = "list"
}

variable "ami_versions" {
  description = "Version of Windows Server 2019 required by each product"
  type        = "list"
}

variable "owners" {
  description = "Owners of each server being started"
  type        = "list"
}

variable "instance_types" {
  description = "instance type to be started"
  type        = "list"
}

variable "min_size" {
  description = "The minimum size of the auto scale group"
  type        = "list"
}

variable "des_size" {
  description = "The number of instances that should be ruinning in the auto scale group"
  type        = "list"
}

variable "max_size" {
  description = "The maximum size of the auto scale group"
  type        = "list"
}

variable "customisation_scripts" {
  description = "Names of the customisation scripts to run"
  type        = "list"
}

variable "backup_intervals" {
  description = "Number of hours between backups"
  type        = "list"
}

variable "backups_retained" {
  description = "Number of backups of a volume to keep"
  type        = "list"
}

variable "backup_start_times" {
  description = "Start time in hh:mm format for backups"
  type        = "list"
}

variable "allow_1433_in" {
  type        = "list"
  description = "List of products that allow 1433 TCP (SQL Server) inbound"
}

variable "allow_1434_in" {
  type        = "list"
  description = "List of products that allow 1434 TCP (SQL Server) inbound"
}

variable "allow_rdp_in" {
  type        = "list"
  description = "List of products that allow RDP inbound"
}

variable "allow_ssh_in" {
  type        = "list"
  description = "List of products that allow SSH inbound"
}
