variable "drives" {
  type        = "list"
  description = "List of drives names"
}

variable "devices" {
  type        = "list"
  description = "List of device names"
  default     = ["xvdf", "xvdg", "xvdh", "xvdi", "xvdj", "xdvk", "xvdl", "xvdm", "xvdn", "xvdo"]
}

variable "product" {
  description = "Name of the product"
}

variable "volume_sizes" {
  description = "List of volume sizes in GB"
  type        = "list"
}

variable "environment" {
  description = "environment in which to build (dev,staging,prod)"
}

variable "owner" {
  description = "Name of the owner of the volumes"
}

variable "instance_id" {
  description = "ID of the pre-existing instance to attach to"
}
