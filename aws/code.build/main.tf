resource "aws_codebuild_project" "default" {
  name          = var.build_name
  service_role  = var.role
  description   = var.description
  build_timeout = var.build_timeout
  cache {
    modes = var.cache_mode
    type  = var.cache_type
  }


  artifacts {
    type = var.artifact_type
  }

  environment {
    compute_type    = var.build_compute_type
    image           = var.build_image
    type            = "LINUX_CONTAINER"
    privileged_mode = var.privileged_mode

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
      }
    }
  }

  source {
    buildspec = var.buildspec
    type      = var.source_type
  }

  logs_config {
    cloudwatch_logs {
      group_name  = var.logs_name
      status      = "ENABLED"
      stream_name = "${var.logs_name}-build"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }


  tags = {
    name        = var.build_name
    environment = var.environment
  }
}
