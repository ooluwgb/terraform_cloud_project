variable "cluster_name" { type = string }
variable "node_role_arn" { type = string }
variable "private_subnets" { type = list(string) }

variable "node_groups" {
  description = "Node group definitions"
  type = map(object({
    instance_types = list(string)
    desired_size   = number
    min_size       = number
    max_size       = number
  }))
}

variable "environment" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
