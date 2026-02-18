resource "aws_iam_policy" "default" {
  name        = "_${var.policy_name}"
  description = "Policy for ${var.environment} environment"
  path        = "/"

  policy = templatefile("${path.module}/policies/policy.json.tpl", {
    actions   = jsonencode(var.actions)
    resources = jsonencode(var.resources)
  })
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = var.role_name
  policy_arn = aws_iam_policy.default.arn
}
