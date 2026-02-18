data "aws_ecs_task_definition" "default" {
  task_definition = var.task.family
  depends_on      = [var.task]
}

resource "aws_ecs_service" "default" {
  name            = "${var.service_name}-${var.environment}"
  cluster         = var.cluster_id
  task_definition = "${var.task.family}:${max("${var.task.revision}", "${data.aws_ecs_task_definition.default.revision}")}"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = var.assign_public_ip

    security_groups = [
      var.security_group.id
    ]

    subnets = var.subnet_ids
  }

  load_balancer {
    container_name   = var.container_name
    container_port   = var.container_port
    target_group_arn = var.target_group_arn
  }

  depends_on = [
    var.task,
    var.target_group_arn,
    var.security_group
  ]

  tags = {
    name        = var.service_name
    environment = var.environment
  }
}
