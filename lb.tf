resource "aws_alb_target_group" "main" {
  name        = "tg-${var.service_name}-${var.env}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "HTTPS"
    path                = var.health_check_path ? var.health_check_path : var.path_pattern
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }

  tags = {
    Name        = "tg-${var.service_name}-${var.env}"
    Environment = var.env
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = var.listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = ["${var.path_pattern}*"]
    }
  }

  tags = {
    Name        = "lb-rule-${var.service_name}-${var.env}"
    Environment = var.env
  }

  depends_on = [
    aws_alb_target_group.main
  ]
}
