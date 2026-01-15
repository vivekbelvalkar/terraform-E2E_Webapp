resource "aws_iam_role" "ec2" {
  name = "${var.env}-ems-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    name= "${var.env}-ems-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_s3" {
  role      = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_cw" {
  role      = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_secret" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSecretsManagerClientReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2" {
  role = aws_iam_role.ec2.name
  tags = {
    name= "${var.env}-ems-iam_instance_profile"
  }
}