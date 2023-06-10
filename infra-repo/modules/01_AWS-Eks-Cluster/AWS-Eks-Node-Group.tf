# EKS EC2 Managed Pod Node Service Role
resource "aws_iam_role" "eks_ec2_nodes_service_role" {
  name = "${var.namespace}-EKS_EC2_ServiceRole"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}


resource "aws_key_pair" "nodes_key_pair" {
  key_name   = "${var.namespace}-eks-nodes-key-pair"
  public_key = var.eks_nodes_ssh_public_key
}

# EKS EC2 Managed Nodes Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.main_eks.name
  node_group_name = "${var.namespace}-eks-node-group"
  node_role_arn   = aws_iam_role.eks_ec2_nodes_service_role.arn
  subnet_ids      = var.eks_private_subnets
  ami_type        = var.instance_config.ami_type
  capacity_type   = var.instance_config.capacity_type
  disk_size       = var.instance_config.disk_size
  instance_types  = var.instance_config.instance_types
  scaling_config {
    desired_size = var.scaling_config.desired_size
    max_size     = var.scaling_config.max_size
    min_size     = var.scaling_config.min_size
  }

  update_config {
    max_unavailable = var.scaling_config.max_unavailable
  }
  remote_access {
    ec2_ssh_key = aws_key_pair.nodes_key_pair.id
  }
}
