resource "aws_eip" "eip" {
    domain = "vpc"
    tags = {
      Name = "${var.env}-eip"
    }
}

resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = var.public_subnet-1_id

  tags = {
    Name = "${var.env}-NATgw"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-igw"
  }
}
