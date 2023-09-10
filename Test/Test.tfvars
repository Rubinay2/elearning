#vpc
project_name                = "e-learning"
environment                 = "development"
region                      = "eu-west-2"
vpc-cidr-block              = "10.0.0.0/16"
instance_tenancy            = "default"
enable_dns_hostnames        = true
enable_dns_support          = true
availability_zone           = ["eu-west-2a", "eu-west-2b"]
associate_public_ip_address = true

# subnets
map_public_ip_on_launch                     = true
public_subnets_cidr                         = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidr                        = ["10.0.3.0/24", "10.0.4.0/24"]
descriptor1                                 = "website"
descriptor2                                 = "application"
enable_resource_name_dns_a_record_on_launch = true


fargate_memory             = 4096
fargate_cpu                = 2048
app_count                  = "2"
app_image                  = "nginx:latest"
app_port                   = "80"
docker_image_tag           = "latest"
immutable_ecr_repositories = true
domain_name                = "rubinay.com"
alternative_name           = ["*.rubinay.com"]


# create security group for the web server / rds
ingressrules = [80]
egressrules  = [0]
ingressrules-rds  = [5432]
egressrules-rds   = [0]
database-subnets  = "database-subnets"
engine            = "mysql"
engine_version    = "8.0.31"
identifier        = "dev-rds-instance"
username          = "rubin"
password          = "rubin123"
instance_class    = "db.t2.micro"
allocated_storage = 200
db_name           = "application"
skip_final_snapshot = true


