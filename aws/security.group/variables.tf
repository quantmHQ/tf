variable "sg_name" {
  description = "security group name"
}

variable "environment" {
  # Simply a string for 'live', 'stage' or 'dev'
  description = "The environment of the resources"
  type        = string
}

variable "vpc" {
  description = "The identifier of the VPC in which to create security group."
}

variable "ingress_ports" {
  description = "The port number on which resource will allow incoming traffic."
  type        = list(number)
}

variable "egress_port" {
  description = "The port number on which resource will allow outgoing traffic."
  type        = number
  default     = 0
}

variable "ingress_protocol" {
  description = "Protocol type of incoming traffic"
  default     = "tcp"
}

variable "egress_protocol" {
  description = "protocol type of outgoing traffic"
  default     = "-1"
}

variable "ingress_cidr_blocks" {
  description = ""
  type        = list(string)
  default     = []
}

variable "egress_cidr_blocks" {
  description = ""
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "security_group_ids" {
  description = "list of Security group ids. "
  type        = list(string)
  default     = []

}
