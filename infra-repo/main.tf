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

provider "aws" {}

# VPC Module
# As an alternative to this module we can use the AWS VPC module(https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
module "eks_vpc" {
  source                      = "./modules/00_AWS-EKS-Vpc-2Azs-4Subnets"
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
  eks_cluster_name         = var.eks_cluster_name
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
  source = "./modules/02_k8s-configuration"
  k8s_cluster_config = {
    endpoint               = module.eks_cluster.simple_http_cluster.endpoint
    cluster_ca_certificate = module.eks_cluster.simple_http_cluster.certificate_authority[0].data
    name                   = module.eks_cluster.simple_http_cluster.id
    arn                    = module.eks_cluster.simple_http_cluster.arn
  }
  workernodes_role_arn = module.eks_cluster.workernodes_role_arn
}