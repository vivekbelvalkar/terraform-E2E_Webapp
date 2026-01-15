resource "aws_ssm_parameter" "ems_db_host" {
  name  = "${var.env}-ems-db-host"
  type  = "String"
  value = var.db_host
}

resource "aws_ssm_parameter" "ems_db_port" {
  name  = "${var.env}-ems-db-port"
  type  = "String"
  value = var.db_port
}