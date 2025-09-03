variable "name" {
  description = "Prefix for IAM roles"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the OIDC provider (without https://)"
  type        = string
}

variable "irsa_configs" {
  description = "Map of IRSA roles with service account and policy ARNs"
  type = map(object({
    namespace      = string
    serviceaccount = string
    policy_arn     = string
  }))
  default = {}
}
