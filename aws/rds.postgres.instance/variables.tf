variable "db_identifier" {
  description = "cluster identifier of RDS"
}

variable "sg_name" {

}

variable "environment" {
  # Simply a string for 'live', 'stage' or 'dev'
  description = "The environment of the resources"
}

variable "db_name" {
  description = "database name"
}

variable "db_user" {
  description = "database master user"
}

variable "db_pass" {
  description = "database password"
}

variable "engine_version" {
  description = "database engine version"
  default     = "16.3"
}

variable "security_group" {
  description = "security group of rds"
}

variable "private_subnet_ids" {
  description = "list of private subnet IDs"
}

variable "storage_type" {
  description = "One of standard (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  default     = "gp2"
}
