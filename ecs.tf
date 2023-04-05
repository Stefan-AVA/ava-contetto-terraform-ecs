data "aws_ecr_image" "main" {
  repository_name = var.repo_name
  image_tag       = "latest"

  depends_on = [null_resource.deploy_image]
}

resource "aws_ecs_task_definition" "main" {
  family = "${var.service_name}-${var.env}"
  # container_definitions = file("container-def.json")
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  # task_role_arn            = aws_iam_role.ecs_task_role.arn
  depends_on = [null_resource.deploy_image]

  container_definitions = jsonencode([
    {
      name      = "${var.service_name}-container"
      image     = "${var.ecr}/${var.repo_name}:latest@${data.aws_ecr_image.main.image_digest}"
      essential = true
      # environment     = var.container_environment
      portMappings = [{
        protocol      = "tcp"
        containerPort = var.container_port
        # hostPort      = 80
      }],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-stream-prefix" : "${var.service_name}"
          "awslogs-group" : "${aws_cloudwatch_log_group.log.name}",
          "awslogs-region" : "${var.region}"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "main" {
  name                               = "${var.service_name}-service"
  cluster                            = var.cluster_id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  platform_version                   = "1.3.0"
  force_new_deployment               = true

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = "${var.service_name}-container"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_lb_listener_rule.main, aws_iam_role_policy_attachment.ecs_task_execution_role, aws_ecs_task_definition.main, aws_security_group.ecs_tasks]
}
