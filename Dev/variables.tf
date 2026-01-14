variable "env" {
    type = string
    default = "dev"
}

variable "region" {
    type = string
    default = "ap-south-1"
}

variable "github_owner" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "app_user" {
  type = string
}

variable "app_password" {
  type = string
  sensitive = true
}

variable "database" {
  type = string
}

variable "master_user" {
  type = string

}

variable "master_pass" {
  type = string
  sensitive = true
}