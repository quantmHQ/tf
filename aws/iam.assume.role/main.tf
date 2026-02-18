resource "aws_iam_role" "default" {
  name        = "_${var.role_name}"
  description = "Role for ${var.environment} environment"

  assume_role_policy = templatefile("${path.module}/policies/role.json.tpl", {
    services = jsonencode(var.services)
  })
}
