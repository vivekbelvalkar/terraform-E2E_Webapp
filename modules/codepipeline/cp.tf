resource "aws_codepipeline" "ems-codepipeline" {
  name     = "${var.env}-ems-codepipeline"
  role_arn = var.role_arn

  artifact_store {
    location = var.bucket
    type     = "S3"
  }
  tags = {
    name="${var.env}-ems-codepipeline"
    }

    stage {
    name = "Source"
    action {
      name             = "GitHub"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo
        Branch     = "main"
        OAuthToken = var.github_token
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["build"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  stage {
  name = "DB-Bootstrap"

  action {
    name            = "InvokeLambda"
    category        = "Invoke"
    owner           = "AWS"
    provider        = "Lambda"
    version         = "1"
    input_artifacts = ["build"]

    configuration = {
      FunctionName = var.db_bootstrap_lambda_func_name
    }
  }
}

stage {
  name = "Deploy"

  action {
    name            = "ASG-Instance-Refresh"
    category        = "Build"
    owner           = "AWS"
    provider        = "CodeBuild"
    version         = "1"
    input_artifacts = ["build"]

    configuration = {
      ProjectName = var.asg_refresh_codebuild_project_name
    }
  }
}


  # stage {
  # name = "Deploy"

  # action {
  #   name            = "Deploy_To_EC2"
  #   category        = "Deploy"
  #   owner           = "AWS"
  #   provider        = "CodeDeploy"
  #   version         = "1"

  #   input_artifacts = ["build_output"]

  #   configuration = {
  #     ApplicationName     = var.codedeploy_app_name
  #     DeploymentGroupName = var.codedeploy_deployment_group
  #     }
  #   }
  # }

}
