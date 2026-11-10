resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/ecs/${var.project_name}-${var.environment}-logs"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-${var.environment}-log-group"
  }
}