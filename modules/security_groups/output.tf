output "mysql-rds-sg" {
    value = aws_security_group.mysql-rds-sg.id
}

output "webservers-security-group-id" {
    value = aws_security_group.webservers-security-group.id
}

output "webservers-alb-sg-id" {
    value = aws_security_group.webservers-alb-sg.id
}