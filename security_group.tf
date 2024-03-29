

resource "aws_security_group" "ecs_tasks" {
  name   = "${var.app_name}-sg-${var.service_name}-${var.env}"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_name}-sg-${var.service_name}-${var.env}"
    Environment = var.env
  }
}
