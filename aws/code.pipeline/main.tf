resource "aws_codepipeline" "default" {
  name = var.pipeline_name

  role_arn = var.role_arn

  artifact_store {
    location = var.pipeline_artifacts_bucket
    type     = "S3"
  }

  dynamic "stage" {
    for_each = [for value in var.stages : {
      name   = value.name
      action = value.action
    }]

    content {
      name = stage.value.name
      action {
        name             = stage.value.action["name"]
        owner            = stage.value.action["owner"]
        version          = stage.value.action["version"]
        category         = stage.value.action["category"]
        provider         = stage.value.action["provider"]
        input_artifacts  = stage.value.action["input_artifacts"]
        output_artifacts = stage.value.action["output_artifacts"]
        configuration    = stage.value.action["configuration"]
      }
    }
  }
}
