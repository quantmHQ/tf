variable "name" {
  description = "name of the bucket, if prefix is given, this is not taken"
  type        = string
  default     = null
}

variable "prefix" {
  description = "prefix of the bucket"
  type        = string
  default     = null
}

variable "is_versioned" {
  description = "check if the bucket is versioned or not"
  type        = bool
  default     = false
}

variable "cors_rules" {
  description = "list of cors_rule in terraform format"
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "tags to apply to the bucket"
  type        = map(any)
}

variable "sse_algorithm" {
  description = "server side encryption algorithm"
  type        = string
  default     = "AES256"
}

variable "website" {
  description = "website property, see https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#website"
  type        = map(any)
  default     = null
}
