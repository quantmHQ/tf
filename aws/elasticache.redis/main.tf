#elastic cache

resource "aws_elasticache_subnet_group" "default" {
  name       = "${var.sg_name}-subnet-group-${var.environment}"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_cluster" "default" {
  cluster_id           = "${var.redis_cluster_name}-${var.environment}"
  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = var.cache_nodes
  parameter_group_name = "default.redis5.0"
  port                 = var.port

  subnet_group_name = aws_elasticache_subnet_group.default.name
  security_group_ids = [
    var.security_group.id
  ]

  depends_on = [
    aws_elasticache_subnet_group.default,
    var.security_group
  ]

  tags = {
    name        = var.redis_cluster_name
    environment = var.environment
  }
}
