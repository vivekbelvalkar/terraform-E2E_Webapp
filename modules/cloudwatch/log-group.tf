resource "aws_cloudwatch_log_group" "app" {
  name              = "/springboot/app"
  retention_in_days = 2
}