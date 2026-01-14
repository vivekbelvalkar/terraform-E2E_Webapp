resource "aws_iam_role" "codepipeline" {
  name = "${var.env}-ems-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "codepipeline.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    name= "${var.env}-ems-codepipeline-role"
  }
}

resource "aws_iam_role_policy_attachment" "codepipeline_full" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
}