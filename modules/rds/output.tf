output "db_host" {
  value = aws_db_instance.mysql-rds.address
}

output "db_port" {
    value = aws_db_instance.mysql-rds.port
}
