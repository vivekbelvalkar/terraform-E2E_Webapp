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

# resource "aws_iam_role_policy_attachment" "codepipeline_full" {
#   role       = aws_iam_role.codepipeline.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
# } -----> Did not work , hence inline policy (this one can be used instead "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess")

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "dev-ems-codepipeline-policy"
  role = aws_iam_role.codepipeline.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
        "lambda:InvokeFunction",
        "codebuild:StartBuild"
         ]
        Resource = "*"
      }
    ]
  })
}
