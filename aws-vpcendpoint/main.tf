module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
  cidr_private_subnet  = var.cidr_private_subnet
}

module "security_group" {
  source              = "./security-groups"
  ec2_sg_name         = "SG for EC2 to enable SSH(22), HTTPS(443), HTTP(8080) and HTTP(80)"
  vpc_id              = module.networking.dev_proj_1_vpc_id
  ec2_jenkins_sg_name = "Allow port 8080 for jenkins"
}

module "vpce_endpoint" {
  source            = "./vpc-endpoint"
  vpc_id            = module.networking.dev_proj_1_vpc_id
  service_name      = "com.amazonaws.eu-west-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [module.networking.dev_proj_1_private_route_table_ids]
}

module "ec2-public-subnet" {
  source                   = "./ec2"
  ami_id                   = var.ec2_ami_id
  instance_type            = "t2.medium"
  tag_name                 = "EC2 Instance: Public Subnet"
  public_key               = var.public_key
  subnet_id                = tolist(module.networking.dev_proj_1_public_subnets_ids )[0]
  sg_for_jenkins           = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address = true
  key_name                 = "aws_ec2_terraform_public"
}

module "ec2-private-subnet" {
  source                   = "./ec2"
  ami_id                   = var.ec2_ami_id
  instance_type            = "t2.medium"
  tag_name                 = "EC2 Instance: Private Subnet"
  public_key               = var.public_key
  subnet_id                = tolist(module.networking.dev_proj_1_private_subnets_ids)[0]
  sg_for_jenkins           = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address = false
  key_name                 = "aws_ec2_terraform_private"
  #user_data_install_jenkins = templatefile("./jenkins-runner-script/jenkins-installer.sh", {})
}
