resource "aws_subnet" "public_subnet-1" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch=true
  tags = {
    Name = "${var.env}-public_subnet-1"
  }
}

resource "aws_subnet" "public_subnet-2" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}b"
  map_public_ip_on_launch=true
  tags = {
    Name = "${var.env}-public_subnet-2"
  }
}


resource "aws_subnet" "private_subnet-1" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.env}-private_subnet-1"
  }
}

resource "aws_subnet" "private_subnet-2" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.5.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "${var.env}-private_subnet-2"
  }
}