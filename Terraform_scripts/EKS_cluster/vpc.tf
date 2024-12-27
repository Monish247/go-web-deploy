locals {
  region = "us-east-1"
  name   = "go-web-cluster"
  vpc_cidr = "10.0.0.0/16"
  azs      = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  intra_subnets   = ["10.0.5.0/24", "10.0.6.0/24"]
  tags = {
    Example = local.name
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets

  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "public" {
  count                   = length(local.public_subnets)
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = element(local.public_subnets, count.index)
  availability_zone       = element(local.azs, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = "${local.name}-public-subnet-${count.index}"
      "kubernetes.io/role/elb" = 1
    },
    local.tags
  )
}
