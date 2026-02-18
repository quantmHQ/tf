resource "aws_security_group" "default" {
  name   = "${var.sg_name}-${var.environment}"
  vpc_id = var.vpc.id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = var.ingress_protocol
      cidr_blocks     = var.ingress_cidr_blocks
      security_groups = var.security_group_ids
    }
  }

  egress {
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = var.egress_protocol
    cidr_blocks = var.egress_cidr_blocks
  }

  tags = {
    name        = "${var.sg_name}"
    environment = var.environment
  }
}
