resource "aws_secretsmanager_secret" "ems_db_master" {
  name = "${var.env}-ems-db-master-credentials"
  tags = {
    name= "${var.env}-ems-db-master-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "ems_db_master_creds" {
  secret_id = aws_secretsmanager_secret.ems_db_master.id

  secret_string = jsonencode({
    username = var.master_user
    password = var.master_pass
  })
}

resource "aws_secretsmanager_secret" "ems_db_appuser" {
  name = "${var.env}-ems-db-appuser-credentials"
  tags = {
    name= "${var.env}-ems-db-appuser-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "ems_db_appuser_creds" {
  secret_id = aws_secretsmanager_secret.ems_db_appuser.id

  secret_string = jsonencode({
    username = var.app_user
    password = var.app_password
    database = var.database
  })
}


