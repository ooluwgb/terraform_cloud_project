module "network" {
  source   = "../../modules/network"
  vpc_cidr = var.vpc_cidr
  tags     = { App = "myapp-prod" }
}

output "vpc_id" {
  value = module.network.vpc_id
}
