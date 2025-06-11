
module "vpc" {
    source = "./modules/vpc"

    project_name        = var.project_name
    vpc_cidr           = var.vpc_cidr
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    availability_zones = var.availability_zones
}

module "security_groups" {
  source = "./modules/security_groups"
  
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  app_port = var.app_port

}

module "ec2_asg" {
  source = "./modules/ec2_asg"

  project_name = var.project_name
  ami_id = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_id = module.vpc.vpc_id
  ec2_sg_id = module.security_groups.ec2_sg_id
  user_data_script = file("${path.module}/scripts/user_data.sh")
  private_subnet_ids = module.vpc.private_subnet_ids
  asg_min_size = var.asg_min_size
  asg_max_size = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity
  
}

module "load_balancer" {
  source = "./modules/load_balancer"

  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  public_subnets_ids   = module.vpc.public_subnet_ids
  alb_sg_id            = module.security_groups.alb_sg_id
  asg_name            = module.ec2_asg.asg_name
  target_group_port = var.app_port
  target_group_protocol = "HTTP"
}