terraform {
  required_version = ">= 0.12"
}

resource "random_id" "rand" {
  keepers = {
    video_in_bucket  = var.video_in_bucket
    video_out_bucket = var.video_out_bucket
    role             = var.role.name
  }

  byte_length = 8
}

resource "aws_sqs_queue" "api_transcode" {
  name                      = "dbl-api-${var.scope}"
  max_message_size          = 262144  # 256KB
  message_retention_seconds = 1209600 # 14 days

  tags = {
    name        = "api-transcode"
    environment = var.environment
    scope       = var.scope
  }
}

resource "aws_sns_topic" "transcode_success" {
  name         = "transcode-success-${var.scope}-${random_id.rand.hex}"
  display_name = "transcode-success-${var.scope}-${random_id.rand.hex}"

  tags = {
    name        = "transcode-success"
    environment = var.environment
    scope       = var.scope
  }
}

resource "aws_elastictranscoder_pipeline" "transcoder" {
  name = "transcoder-${var.scope}-${random_id.rand.hex}"
  role = var.role.arn

  input_bucket  = var.video_in_bucket
  output_bucket = var.video_out_bucket

  notifications {
    completed = aws_sns_topic.transcode_success.arn
  }

  depends_on = [
    aws_sns_topic.transcode_success,
    var.video_in_bucket,
    var.video_out_bucket,
  ]
}
