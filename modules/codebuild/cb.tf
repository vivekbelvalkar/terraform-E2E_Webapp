resource "aws_codebuild_project" "ems-codebuild" {
  name          = "${var.env}-ems-codebuild"
  service_role = var.role_arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "BUCKET_NAME"
      value = var.bucket
    }
  }

  artifacts { 
    type = "CODEPIPELINE" 
    }

  tags = {
    name= "${var.env}-ems-codebuild"
  }
}

resource "aws_codebuild_project" "asg_refresh" {
  name          = "${var.env}-asg-refresh"
  service_role = var.role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "ASG_NAME"
      value = var.asg_name
    }
  }

  source {
    type      = "NO_SOURCE"
    buildspec = <<-EOF
  version: 0.2

  phases:
    build:
      commands:
        - echo "Starting ASG instance refresh"
        - aws autoscaling start-instance-refresh --auto-scaling-group-name $ASG_NAME --preferences MinHealthyPercentage=50
EOF
  }
}
