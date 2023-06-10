vpc_config = {
  cidr_block                  = "10.0.0.0/16"
  subnet_public_a_cidr_block  = "10.0.1.0/24"
  subnet_public_b_cidr_block  = "10.0.2.0/24"
  subnet_private_a_cidr_block = "10.0.11.0/24"
  subnet_private_b_cidr_block = "10.0.21.0/24"
}
eks_nodes_config = {
  scaling_config = {
    desired_size    = 2
    max_size        = 2
    min_size        = 2
    max_unavailable = 1
  }
  instance_config = {
    ami_type = "AL2_x86_64"
    capacity_type = "ON_DEMAND"
    disk_size = 20
    instance_types = ["t3.medium"]
  }
}
enable_public_grafana = true
operational_environments = [
  {
    name = "staging"
  },
  {
    name = "production"
  }
]
