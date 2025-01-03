module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

  cluster_name                   = local.name
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = aws_subnet.public[*].id

  eks_managed_node_groups = {
    dev-node = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t2.medium"]
      capacity_type  = "SPOT"
      key_name       = var.ssh_key_name  # Use the variable for the key name

      tags = {
        ExtraTag = "Panda_Node"
      }
    }
  }

  tags = local.tags
}
