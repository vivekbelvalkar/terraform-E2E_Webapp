output "codebuild_project_name" {
  value = aws_codebuild_project.ems-codebuild.name
}
output "asg_refresh_codebuild_project_name" {
  value = aws_codebuild_project.asg_refresh.name
}