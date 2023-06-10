variable "namespace" {
  description = "Namespace to be used as a prefix for all resources"
  type        = string
}

variable "eks_nodes_ssh_public_key" {
  type        = string
  description = "SSH public key to use for EKS nodes"
}
variable "eks_vpc_id" {
  type        = string
  description = "VPC ID to use for EKS cluster"
}
variable "eks_private_subnets"{
  type = list(string)
  description = "List of private subnets to use for the EKS cluster"
}
variable "eks_public_subnets"{
  type = list(string)
  description = "List of public subnets to use for the EKS cluster"
}

variable "scaling_config"{
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
    max_unavailable = number
  })
  description = "Scaling configuration for EKS nodes"
}
variable "instance_config"{
  type = object({
    ami_type       = string
    capacity_type  = string
    disk_size      = number
    instance_types = list(string)
  })
  description = "Instance configuration for EKS nodes"
}