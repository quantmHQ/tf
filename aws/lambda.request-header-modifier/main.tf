data "archive_file" "code_file" {
  source_file = "${path.module}/index.js"
  type        = "zip"
  output_path = "${path.module}/request_header_modifier.zip"
}

resource "aws_lambda_function" "default" {
  filename      = data.archive_file.code_file.output_path
  function_name = var.function_name
  publish       = true
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  #   source_code_hash = filebase64sha256("${path.module}/request_header_modifier.zip")

  tracing_config {
    mode = "PassThrough"
  }
}
