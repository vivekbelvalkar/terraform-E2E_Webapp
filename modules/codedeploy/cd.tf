resource "aws_codedeploy_app" "ems-codedeploy" {
  name = "${var.env}-ems-codedeploy"
  compute_platform = "Server"
  tags = {
    name= "${var.env}-ems-codedeploy"
  }
}

resource "aws_codedeploy_deployment_group" "ems-codedeploy-dg" {
  app_name              = aws_codedeploy_app.ems-codedeploy.name
  deployment_group_name = "${var.env}-ems-codedeploy-dg"
  service_role_arn      = var.codedeploy_role_arn

  autoscaling_groups = [var.asg_name]

  deployment_style {
    deployment_type   = "IN_PLACE"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  load_balancer_info {
    target_group_info {
      name = var.target_group_name
    }
  }
  tags = {
    name= "${var.env}-ems-codedeploy-dg"
  }
}