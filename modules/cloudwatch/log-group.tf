resource "aws_cloudwatch_log_group" "app" {
  name              = "/ems/${var.env}/app"
  retention_in_days = 1
  tags = {
    name = "${var.env}-ems-cw-log-group"
  }
}