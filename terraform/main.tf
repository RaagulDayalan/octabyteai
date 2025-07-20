provider "aws" {
  region = "us-east-1"
  profile = "terraform-user"
}

module "vpc" {
  source = "./vpc"
  infra_prefix=var.infra_prefix
  availability_zone_1=var.availability_zone_1
  availability_zone_2=var.availability_zone_2
  
}

module "ec2" {
  source = "./ec2"
  infra_prefix=var.infra_prefix
  ami_id=var.ami_id
  instance_type=var.instance_type
  instance_volume = var.instance_volume
  subnet_ids = module.vpc.subnet_ids
  iam_ec2_cw_role=module.iam.iam_ec2_cw_role
  vpc_id=module.vpc.vpc_id
  app_domain_cert=var.app_domain_cert
  office_ip = var.office_ip
  public_subnet=module.vpc.public_subnet

  bastion_key_file = var.bastion_key_file
  application_key_file = var.application_key_file
  
}

module "iam" {
  source = "./iam"
  infra_prefix=var.infra_prefix
}
module "rds" {
  source = "./rds"
  infra_prefix=var.infra_prefix
  ec2_rds_sg = module.ec2.ec2_rds_sg
  db_instnace_type = var.db_instnace_type
  SECRET = var.SECRET 
  subnet_ids = module.vpc.subnet_ids
  
}