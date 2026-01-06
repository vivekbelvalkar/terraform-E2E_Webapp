variable "env" {}
variable "vpc_id" {} 
variable "public_subnet-1_id" {}
variable "public_subnet-2_id" {}
variable "webservers-alb-sg-id" {}
variable "create_lb" {
    type = bool
}