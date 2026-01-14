resource "aws_cloudwatch_log_group" "app" {
  name              = "/ems/app"
  retention_in_days = 2
  tags = {
    name = "${var.env}-ems-cw-log-group"
  }
}