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
  }

  artifacts { 
    type = "CODEPIPELINE" 
    }

  tags = {
    name= "${var.env}-ems-codebuild"
  }
}
