resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "${var.env}-ems-public_rt"
  }
}

resource "aws_route_table_association" "public_rt-public_subnet-1" {
  subnet_id      = var.public_subnet-1_id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt-public_subnet-2" {
  subnet_id      = var.public_subnet-2_id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.NATgw_id
  }

  tags = {
    Name = "${var.env}-ems-private_rt"
  }
}

resource "aws_route_table_association" "private_rt-private_subnet-1" {
  subnet_id      = var.private_subnet-1_id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt-private_subnet-2" {
  subnet_id      = var.private_subnet-2_id
  route_table_id = aws_route_table.private_rt.id
}