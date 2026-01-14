resource "aws_secretsmanager_secret" "ems_db" {
  name = "${var.env}-ems-db-credentials"
  tags = {
    name= "${var.env}-ems-db-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "ems_db_appuser_creds" {
  secret_id = aws_secretsmanager_secret.ems_db.id

  secret_string = jsonencode({
    username = var.app_user
    password = var.app_password
    database = var.database
  })
}

resource "aws_secretsmanager_secret_version" "ems_db_master_creds" {
  secret_id = aws_secretsmanager_secret.ems_db.id

  secret_string = jsonencode({
    username = var.master_user
    password = var.master_pass
  })
}
