resource "aws_ecs_task_definition" "default" {
  family       = "${var.name}-${var.environment}"
  network_mode = "awsvpc"
  cpu          = 256
  memory       = 512
  container_definitions = templatefile("${path.module}/templates/task.json.tpl", {
    name                  = var.name
    image                 = var.image
    command               = jsonencode(var.command)
    port_mappings         = jsonencode(var.port_mappings)
    db_host               = var.db_host
    db_name               = var.db_name
    db_user               = var.db_user
    db_pass               = var.db_pass
    redis_host            = var.redis_host
    sqs_namespace         = var.sqs_namespace
    accounts_email        = var.accounts_email
    sns_transcode_success = var.sns_transcode_success
    transcode_pipeline_id = var.transcode_pipeline_id
    stripe_api_secret     = var.stripe_api_secret
    stripe_api_key        = var.stripe_api_key
    facebook_app_id       = var.facebook_app_id
    twitter_site          = var.twitter_site
    twitter_creator       = var.twitter_creator
    email_base_url        = var.email_base_url
    root_url_conf         = var.root_url_conf
    video_in_bucket       = var.video_in_bucket
    video_out_bucket      = var.video_out_bucket
    assets_bucket         = var.assets_bucket
    ip_info_api_key       = var.ip_info_api_key
    stage                 = var.environment
  })

  requires_compatibilities = ["FARGATE"]

  execution_role_arn = var.role.arn

  task_role_arn = var.role.arn

  tags = {
    name        = var.name
    environment = var.environment

  }
}
