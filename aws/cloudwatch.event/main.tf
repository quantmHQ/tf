resource "aws_cloudwatch_event_rule" "default" {
  name     = var.name
  role_arn = var.role_arn

  event_pattern = jsonencode({
    detail = {
      eventName = [
        "CopyObject",
        "CompleteMultiPartUpload",
        "PutObject",
      ]
      eventSource = [
        "s3.amazonaws.com",
      ]
      requestParameters = {
        bucketName = [
          var.pipeline_source_bucket,
        ]
        key = [
          var.key,
        ]
      }
    }
    detail-type = [
      "AWS API Call via CloudTrail",
    ]
    source = [
      "aws.s3",
    ]
  })
}

resource "aws_cloudwatch_event_target" "default" {
  rule      = aws_cloudwatch_event_rule.default.name
  arn       = var.code_pipeline_arn
  target_id = var.target_id
  role_arn  = var.role_arn
}
