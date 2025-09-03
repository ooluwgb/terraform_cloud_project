variable "name" { type = string }
variable "cluster_version" {
  type    = string
  default = "1.31"
}

variable "cluster_role_arn" { type = string }

variable "private_subnets" { type = list(string) }
variable "public_subnets" { type = list(string) }

variable "cluster_security_groups" {
  type    = list(string)
  default = []
}

variable "public_access_cidrs" {
  description = "Allowed CIDRs for public API access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "environment" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
