# Variables for Dev. Environment

# Environment variables
variable "project_name" {}

variable "environment" {}


# Creating variables for AWS region.
variable "region" {}

variable "descriptor1" {}

variable "descriptor2" {}

# Creating variables for VPC CIDR block.
variable "vpc-cidr-block" {}

variable "instance_tenancy" {}

variable "enable_dns_hostnames" {}

variable "enable_dns_support" {}

variable "availability_zone" {}

variable "map_public_ip_on_launch" {}

variable "enable_resource_name_dns_a_record_on_launch" {}

# Creating variables for Subnets CIDR block

variable "public_subnets_cidr" {}

variable "private_subnets_cidr" {}

variable "associate_public_ip_address" {}



variable "fargate_cpu" {}

variable "fargate_memory" {}

variable "app_count" {}

variable "app_image" {}

variable "app_port" {}

variable "docker_image_tag" {}

variable "immutable_ecr_repositories" {}

variable "domain_name" {}

variable "alternative_name" {}

#variable "e-learningSG" {}

variable "ingressrules" {}

variable "egressrules" {}

variable "ingressrules-rds" {}

variable "egressrules-rds" {}

variable "database-subnets" {}

variable "engine" {}

variable "engine_version" {}

variable "username" {}

variable "password" {}

variable "instance_class" {}

variable "allocated_storage" {}

variable "db_name" {}

variable "skip_final_snapshot" {}

variable "identifier" {}
