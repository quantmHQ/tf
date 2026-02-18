variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string

}
variable "role_arn" {
  description = "IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to "
  type        = string

}

variable "handler" {
  description = "The function entrypoint in your code"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "The identifier of the function's runtime."
  type        = string
  default     = "nodejs10.x"

}
