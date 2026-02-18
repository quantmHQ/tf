variable "name" {
  description = "The name of the resource"
  type        = string
}

variable "environment" {
  description = "The environment of the resources"
}

variable "role" {
  description = "arn of IAM role"
}

variable "image" {}
variable "command" {}
variable "port_mappings" {}
variable "db_host" {}
variable "db_name" {}
variable "db_user" {}
variable "db_pass" {}
variable "redis_host" {}
variable "sqs_namespace" {}
variable "sns_transcode_success" {}
variable "transcode_pipeline_id" {}
variable "email_base_url" {}
variable "root_url_conf" {}
variable "video_in_bucket" {}
variable "video_out_bucket" {}
variable "assets_bucket" {}
variable "stripe_api_key" {}
variable "stripe_api_secret" {}
variable "accounts_email" {}
variable "facebook_app_id" {}
variable "twitter_site" {}
variable "twitter_creator" {}
variable "ip_info_api_key" {}
