# variable AWS_ACCESS_KEY {}
# variable AWS_SECRET_KEY {}
variable "env" {}
variable "webservers-security-group-id" {}
variable "public_subnet-1_id" {}
variable "public_subnet-2_id" {}
variable "load-balancer-target-group-arn" {}
variable "webservers-key-pair-key_name" {}
variable "instance_profile" {}
variable "artifact_bucket" {}
variable "db_host" {}
variable "db_port" {}

data "aws_ec2_instance_types" "free_tier_instances_type" {
    filter {
        name   = "free-tier-eligible"
        values = ["true"]
    }
    filter {
    name   = "instance-type"
    values = ["t3*"]
  }
}

data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    filter {
    name   = "name"
    values = ["*ubuntu-noble-24.04-amd64-server*"]
  }
    owners = ["099720109477"] # Canonical
}



