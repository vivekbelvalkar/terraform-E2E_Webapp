variable "env" {
    type = string
    default = "si"
}

variable "region" {
    type = string
    default = "ap-south-1"
}
variable "webserver_key_pair_name" {
  type = string
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

variable "sql_data_s3_key"{
  type = string
}

variable "create_lb" {
  type = bool
}