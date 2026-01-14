resource "aws_codebuild_project" "ems-codebuild" {
  name          = "${var.env}-ems-codebuild"
  service_role = var.role_arn

  artifacts { type = "CODEPIPELINE" }
  tags = {
    name= "${var.env}-ems-codebuild"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}
