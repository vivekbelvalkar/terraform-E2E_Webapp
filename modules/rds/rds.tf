resource "aws_db_instance" "mysql-rds" {
  identifier = "${var.env}-ems-mysql-rds"
  allocated_storage = "10"
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  backup_retention_period = "0"
  publicly_accessible = "true"
  username = var.master_user
  password = var.master_pass
  port = "3306"
  vpc_security_group_ids = [var.mysql-rds-sg-id]
  db_subnet_group_name = aws_db_subnet_group.mysql-rds-subnet-group.name
  parameter_group_name = aws_db_parameter_group.mysql-parameter-group.name
  multi_az = "false"
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "mysql-rds-subnet-group" {

    name          = "${var.env}-ems-mysql-rds-subnet-group"
    description   = "Allowed subnets for DB cluster instances"
    subnet_ids    = [
      var.private_subnet-1_id,
      var.private_subnet-2_id,
    ]
    tags = {
        Name         = "${var.env}-ems-mysql-rds-subnet-group"
    }
}

resource "aws_db_parameter_group" "mysql-parameter-group" {
  name   = "${var.env}-ems-mysql-parameter-group"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
  tags = {
        Name         = "${var.env}-ems-mysql-parameter-group"
    }
}

