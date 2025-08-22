module "network" {
  source   = "../../modules/network"
  vpc_cidr = var.vpc_cidr
  tags     = { App = "myapp-dev" }
}

output "vpc_id" {
  value = module.network.vpc_id
}
