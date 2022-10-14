resource "aws_cloudwatch_log_group" "log" {
  name              = "${var.app_name}/${var.env}/${var.service_name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "stream"
  log_group_name = aws_cloudwatch_log_group.log.name
}