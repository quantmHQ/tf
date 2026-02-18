output "transcoder" {
  value = {
    sqs      = aws_sqs_queue.api_transcode
    sns      = aws_sns_topic.transcode_success
    pipeline = aws_elastictranscoder_pipeline.transcoder
  }
}
