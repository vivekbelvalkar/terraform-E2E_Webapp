output "codedeploy_app_name" {
  value = aws_codedeploy_app.ems-codedeploy.name
}
output "codedeploy_deployment_group" {
  value = aws_codedeploy_deployment_group.ems-codedeploy-dg.deployment_group_name
}