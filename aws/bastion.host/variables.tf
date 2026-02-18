variable "key_name" {
  description = "key name"
  type        = string
}

variable "vpc" {
  description = "VPC object"
}

variable "zone_id" {
  description = "hosted zone id "
}

variable "cidr_blocks" {
  description = "list of allowed cidr blocks"
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in."
}

variable "domain_name" {
  description = "The domain name"
}
