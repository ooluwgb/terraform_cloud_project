module "vpc" {
  source = "../../modules/aws/vpc"

  name                 = "Development"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

module "sg_web" {
  source      = "../../modules/aws/sg"
  name        = "Development-web-sg"
  description = "Allow HTTP/HTTPS inbound"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}


module "sg_eks" {
  source      = "../../modules/aws/sg"
  name        = "Development-eks-sg"
  description = "Security group for EKS cluster"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = module.vpc.private_subnets_cidrs
    },
  ]
}

module "iam" {
  source = "../../modules/aws/iam"

  name              = "Development_Cluster"
  oidc_provider_arn = module.eks_cluster.cluster_oidc_issuer_arn
  oidc_provider_url = replace(module.eks_cluster.cluster_oidc_issuer, "https://", "")

  irsa_configs = {
    ebs-csi = {
      namespace      = "kube-system"
      serviceaccount = "ebs-csi-controller-sa"
      policy_arn     = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    }
    alb-controller = {
      namespace      = "kube-system"
      serviceaccount = "aws-load-balancer-controller"
      policy_arn     = module.iam.alb_controller_policy_arn
    }
  }
}

module "eks_cluster" {
  source                  = "../../modules/aws/eks/cluster"
  name                    = "my-development-eks"
  cluster_version         = "1.31"
  cluster_role_arn        = module.iam.cluster_role_arn
  private_subnets         = module.vpc.private_subnets
  public_subnets          = module.vpc.public_subnets
  cluster_security_groups = [module.sg_eks.security_group_id]
  public_access_cidrs     = ["0.0.0.0/0"]
  environment             = "development"
}

module "eks_node_groups" {
  source          = "../../modules/aws/eks/node-groups"
  cluster_name    = module.eks_cluster.cluster_name
  node_role_arn   = module.iam.node_role_arn
  private_subnets = module.vpc.private_subnets
  environment     = "development"

  node_groups = {
    general = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 1
      max_size       = 4
    }
  }
}