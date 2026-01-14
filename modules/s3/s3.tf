resource "aws_s3_bucket" "artifact" {
  bucket = "springboot-artifacts-${var.env}"
}