#load balancer
resource "aws_lb" "default" {
  name               = "${var.lb_name}-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    var.security_group.id
  ]
  subnets = var.public_subnet_ids

  tags = {
    name        = var.lb_name
    environment = var.environment
  }
}

#target resource for load balancer
/* resource "aws_lb_target_group" "default" {
  name        = "${var.target_group_name}-${var.environment}"
  port        = var.target_port # target port for load balancer
  protocol    = "HTTP"
  vpc_id      = var.vpc.id
  target_type = var.target_type

  tags = {
    name        = var.target_group_name
    environment = var.environment
  }
}

#http listener
resource "aws_lb_listener" "default_http" {
  load_balancer_arn = aws_lb.default.arn
  port              = 80
  protocol          = "HTTP"

  depends_on = [
    aws_lb_target_group.default
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

#https listener port
resource "aws_lb_listener" "default_https" {
  load_balancer_arn = aws_lb.default.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.lb_certificate_arn

  depends_on = [
    aws_lb_target_group.default
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_route53_record" "default" {
  zone_id = var.zone_id
  name    = "${var.record_name}.${var.domain_name}"
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_lb.default.dns_name
    zone_id                = var.lb_zone_id
  }
} */
