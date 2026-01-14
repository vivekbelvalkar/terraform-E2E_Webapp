resource "aws_s3_bucket" "artifact" {
  bucket = "${var.env}-ems-artifacts"

  tags = {
    Name        = "${var.env}-ems-artifacts"
  }
}