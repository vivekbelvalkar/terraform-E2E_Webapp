resource "aws_security_group" "mysql-rds-sg" {

  name = "${var.env}-ems-mysql-rds-sg"
  description = "Created by Terraform"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    # cidr_blocks = ["10.0.1.0/24"] 
    # Since auto scaler will launch EC2's in any of the public subnets 10.0.1.0/24 or/and 10.0.2.0/24
    # we need to allow webservers securiy groups itself.
    security_groups = [aws_security_group.webservers-security-group.id]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "${var.env}-ems-mysql-rds-sg"
   }
}


resource "aws_security_group" "webservers-security-group"{
  tags = {
    Name = "${var.env}-ems-webservers-security-group"
  }
  
  name          = "${var.env}-ems-webservers-security-group"
  description   = "Created by Terraform"
  vpc_id        = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "webservers-alb-sg" {
  tags = {
    Name = "${var.env}-ems-webservers-alb-sg"
  }
  name = "${var.env}-ems-webservers-alb-sg"
  description = "Created by Terraform"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}