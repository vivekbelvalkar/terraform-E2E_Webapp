locals {
  ems_db_master_creds = jsondecode(
    aws_secretsmanager_secret_version.ems_db_master_creds.secret_string
  )
}

output "master_user" {
  value = local.ems_db_master_creds.username
  sensitive = true
}
output "master_pass" {
  value = local.ems_db_master_creds.password
  sensitive = true
}