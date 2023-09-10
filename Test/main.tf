provider "aws" {
  region = var.region

}


module "e-learning" {
  source                                      = "../child-modules"
  project_name                                = var.project_name
  environment                                 = var.environment
  region                                      = var.region
  vpc-cidr-block                              = var.vpc-cidr-block
  instance_tenancy                            = var.instance_tenancy
  enable_dns_hostnames                        = var.enable_dns_hostnames
  enable_dns_support                          = var.enable_dns_support
  availability_zone                           = var.availability_zone
  map_public_ip_on_launch                     = var.map_public_ip_on_launch
  enable_resource_name_dns_a_record_on_launch = var.enable_resource_name_dns_a_record_on_launch
  associate_public_ip_address                 = var.associate_public_ip_address

  
  descriptor1          = var.descriptor1
  descriptor2          = var.descriptor2
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr


  fargate_cpu                = var.fargate_cpu
  fargate_memory             = var.fargate_memory
  app_count                  = var.app_count
  app_image                  = var.app_image
  app_port                   = var.app_port
  docker_image_tag           = var.docker_image_tag
  immutable_ecr_repositories = var.immutable_ecr_repositories
  domain_name                = var.domain_name
  alternative_name           = var.alternative_name

  
  ingressrules              = var.ingressrules
  egressrules               = var.egressrules
  ingressrules-rds          = var.ingressrules-rds
  egressrules-rds           = var.egressrules-rds
  database-subnets          = var.database-subnets
  engine                    = var.engine
  engine_version            = var.engine_version
  username                  = var.username
  password                  = var.password
  instance_class            = var.instance_class
  allocated_storage         = var.allocated_storage
  db_name                   = var.db_name
  skip_final_snapshot       = var.skip_final_snapshot
  identifier                = var.identifier




}