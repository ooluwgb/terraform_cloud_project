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