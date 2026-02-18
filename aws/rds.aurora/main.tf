resource "aws_db_subnet_group" "default" {
  name       = "${var.sg_name}-subnet-group-${var.environment}"
  subnet_ids = var.private_subnet_ids

  tags = {
    name        = "${var.sg_name}-subnet-group"
    environment = var.environment
  }
}

resource "aws_rds_cluster" "default" {
  cluster_identifier   = "${var.db_cluster_name}-${var.scope}"
  engine               = "aurora-postgresql"
  enable_http_endpoint = true

  # engine
  engine_mode     = "serverless"
  database_name   = var.db_name
  master_username = var.db_user
  master_password = var.db_pass

  # scaling configuration (depends on engine mode serverless)
  scaling_configuration {
    auto_pause               = var.scaling_auto_pause
    min_capacity             = var.scaling_min_capacity
    max_capacity             = var.scaling_max_capacity
    seconds_until_auto_pause = var.scaling_auto_pause_time
    timeout_action           = "ForceApplyCapacityChange"
  }

  # networking
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [
    var.security_group.id,
  ]
  # tags
  tags = {
    name        = var.db_cluster_name
    environment = var.environment
  }
}
