resource "aws_ecs_cluster" "default" {
  name = var.cluster_name

  tags = {
    name        = var.cluster_name
    environment = var.environment
  }
}
