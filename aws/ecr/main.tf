resource "aws_ecr_repository" "default" {
  name = "${var.name}-${var.environment}"

  tags = {
    name        = var.name
    environment = var.environment
  }
}
