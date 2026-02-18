data "aws_ecs_task_definition" "default" {
  for_each        = var.tasks
  task_definition = each.value.task.family
}

locals {
  # filtering publically exposed tasks
  public_tasks = {
    for name, task in var.tasks :
    name => task if try(task.target_group__target_type, null) != null
  }
  task_keys        = keys(local.public_tasks)
  default_listener = length(local.task_keys) > 0 ? toset([local.task_keys[0]]) : toset([])
}

resource "aws_lb_target_group" "default" {
  for_each    = local.public_tasks # only required for publically exposed tasks
  name        = each.value.task.family
  port        = each.value.port
  protocol    = "HTTP"
  vpc_id      = var.vpc.id
  target_type = each.value.target_group__target_type

  tags = {
    name        = each.key
    environment = var.environment
  }
}

resource "aws_lb_listener" "http" {
  for_each          = local.default_listener
  load_balancer_arn = var.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default[each.key].arn
  }
}

resource "aws_lb_listener" "https" {
  for_each          = local.default_listener
  load_balancer_arn = var.load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default[each.key].arn
  }
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  for_each     = local.default_listener
  listener_arn = aws_lb_listener.http[each.key].arn

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      /* values = ["${var.name}.${var.domain_name}"] */
      values = [
        for key, task in var.tasks : "${key}.${var.domain_name}"
      ]
    }
  }
}

resource "aws_lb_listener_rule" "https" {
  for_each     = local.public_tasks
  listener_arn = aws_lb_listener.https[local.task_keys[0]].arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default[each.key].arn
  }

  condition {
    host_header {
      values = ["${each.key}.${var.domain_name}"]
    }
  }
}

resource "aws_route53_record" "default" {
  for_each = local.public_tasks
  zone_id  = var.zone_id
  name     = "${each.key}.${var.domain_name}"
  type     = "A"

  alias {
    evaluate_target_health = false
    name                   = var.load_balancer.dns_name
    zone_id                = var.load_balancer.zone_id
  }
}

/* locals {
  should_create = try(var.load_balancer.arn, null) != null ? 1 : 0
}
} */

resource "aws_ecs_service" "default" {
  for_each        = var.tasks
  name            = var.tasks[each.key].task.family
  cluster         = var.cluster_id
  task_definition = "${var.tasks[each.key].task.family}:${max("${var.tasks[each.key].task.revision}", "${data.aws_ecs_task_definition.default[each.key].revision}")}"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true

    security_groups = [
      var.security_group.id
    ]

    subnets = var.subnet_ids
  }

  # TODO: make this conditional on the target group type
  dynamic "load_balancer" {
    for_each = {
      for key, task in local.public_tasks : key => task if each.key == key
    }
    content {
      container_name   = local.public_tasks[each.key].task.family
      container_port   = local.public_tasks[each.key].port
      target_group_arn = aws_lb_target_group.default[each.key].arn
    }
  }

  depends_on = [
    var.security_group
  ]

  tags = {
    name        = var.tasks[each.key].task.family
    environment = var.environment
  }
}
