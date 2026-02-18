resource "aws_security_group" "default" {
  name   = "bastion-security-group"
  vpc_id = var.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "default" {
  ami                         = "ami-07a6716a7f1ee6d61" # freetier
  key_name                    = var.key_name
  instance_type               = "t2.micro" # freetier
  vpc_security_group_ids      = [aws_security_group.default.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
}

resource "aws_route53_record" "default" {
  zone_id = var.zone_id
  name    = "bastion.${var.domain_name}"
  type    = "A"
  ttl     = "330"
  records = [aws_instance.default.public_ip]
}
