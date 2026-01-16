variable "env" {}
variable "vpc_subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
variable "db_master_secret_arn" {}
variable "db_name" {}
variable "db_host"{}
variable "db_port" {}
variable "app_db_user" {}
variable "app_db_password" {}
variable "sql_data_s3_key" {}
variable "bucket_name" {}
variable "lambda_role_arn" {}