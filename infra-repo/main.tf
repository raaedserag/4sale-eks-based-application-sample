terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
  backend "s3" {}
  required_version = ">= 1.4.6"
}

provider "aws" {
  default_tags {
    tags = {
      Namespace = var.namespace
    }
  }
}

# VPC Module
# As an alternative to this module we can use the AWS VPC module(https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
module "eks_vpc" {
  source                      = "./modules/00_AWS-EKS-Vpc-2Azs-4Subnets"
  namespace                   = var.namespace
  vpc_cidr_block              = var.vpc_cidr_block
  subnet_public_a_cidr_block  = var.subnet_public_a_cidr_block
  subnet_private_a_cidr_block = var.subnet_private_a_cidr_block
  subnet_public_b_cidr_block  = var.subnet_public_b_cidr_block
  subnet_private_b_cidr_block = var.subnet_private_b_cidr_block
}

# EKS Module
# As an alternative to this module we can use the AWS EKS module(https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
module "eks_cluster" {
  source                   = "./modules/01_AWS-Eks-Cluster"
  namespace                = var.namespace
  eks_nodes_ssh_public_key = tls_private_key.key_pair.public_key_openssh
  eks_vpc_id               = module.eks_vpc.vpc.id
  eks_private_subnets = [
    module.eks_vpc.subnet_private_a.id,
    module.eks_vpc.subnet_private_b.id
  ]
  eks_public_subnets = [
    module.eks_vpc.subnet_public_a.id,
    module.eks_vpc.subnet_public_b.id
  ]
}

# K8s Configuration Module
module "k8s_config" {
  source               = "./modules/02_k8s-configuration"
  namespace            = var.namespace
  k8s_cluster_config   = module.eks_cluster.eks_cluster_config
  workernodes_role_arn = module.eks_cluster.workernodes_role_arn
  dockerhub_username   = var.dockerhub_username
  dockerhub_password   = var.dockerhub_password
}

module "eks_grafana_prometheus" {
  source  = "./modules/04_prometheus_grafana"
  k8s_cluster_config = module.eks_cluster.eks_cluster_config
  grafana_admin_password = var.grafana_admin_password
  enable_public_grafana = var.enable_public_grafana
}

# Create operational environments as needed, depending on the variable 'operational_environments'
# This is a list of objects, each object has a key 'environment_name'
module "staging_environment" {
  source             = "./modules/03_operational-environment"
  namespace          = var.namespace
  environment_name   = "staging"
  k8s_cluster_config = module.eks_cluster.eks_cluster_config
  rds_config = {
    vpc_id                      = module.eks_vpc.vpc.id
    subnets                     = [module.eks_vpc.subnet_private_a.id, module.eks_vpc.subnet_private_b.id]
    allowed_inbound_cidr_blocks = [module.eks_vpc.subnet_private_a.cidr_block, module.eks_vpc.subnet_private_b.cidr_block]
  }
}

module "production_environment" {
  source             = "./modules/03_operational-environment"
  namespace          = var.namespace
  environment_name   = "production"
  k8s_cluster_config = module.eks_cluster.eks_cluster_config
  rds_config = {
    vpc_id                      = module.eks_vpc.vpc.id
    subnets                     = [module.eks_vpc.subnet_private_a.id, module.eks_vpc.subnet_private_b.id]
    allowed_inbound_cidr_blocks = [module.eks_vpc.subnet_private_a.cidr_block, module.eks_vpc.subnet_private_b.cidr_block]
  }
}
