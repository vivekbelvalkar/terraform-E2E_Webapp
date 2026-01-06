module "vpc" {
  source = "../modules/vpc"
  env = var.env
}

module "subnet" {
  source = "../modules/subnets"
  vpc_id = module.vpc.vpc_id
  env = var.env
  region = var.region
}

module "gatways" {
  source = "../modules/gateways"
  vpc_id           = module.vpc.vpc_id
  public_subnet-1_id = module.subnet.public_subnet-1_id
  env = var.env
}

module "route_tables"{
  source = "../modules/route_tables"
  env = var.env
  vpc_id = module.vpc.vpc_id
  igw_id= module.gatways.igw_id
  NATgw_id = module.gatways.NATgw_id
  public_subnet-1_id=module.subnet.public_subnet-1_id
  public_subnet-2_id=module.subnet.public_subnet-2_id
  private_subnet-1_id=module.subnet.private_subnet-1_id
  private_subnet-2_id=module.subnet.private_subnet-2_id
}

module "security_groups"{
  source = "../modules/security_groups"
  env = var.env
  vpc_id = module.vpc.vpc_id
}

module "loadbalancer"{
  source = "../modules/loadbalancer"
  env = var.env
  vpc_id = module.vpc.vpc_id
  public_subnet-1_id=module.subnet.public_subnet-1_id
  public_subnet-2_id=module.subnet.public_subnet-2_id
  webservers-alb-sg-id=module.security_groups.webservers-alb-sg-id
  create_lb = false
}

module "webservers"{
  source = "../modules/webservers"
  env=var.env
  webservers-security-group-id=module.security_groups.webservers-security-group-id
  public_subnet-1_id=module.subnet.public_subnet-1_id
  public_subnet-2_id=module.subnet.public_subnet-2_id
  load-balancer-target-group-arn=module.loadbalancer.load-balancer-target-group-arn
  webservers-key-pair-key_name="dev-webservers-key-pair"
}

module "rds"{
  source = "../modules/rds"
  env = var.env
  mysql-rds-sg-id = module.security_groups.mysql-rds-sg
  private_subnet-1_id = module.subnet.private_subnet-1_id
  private_subnet-2_id = module.subnet.private_subnet-2_id
}