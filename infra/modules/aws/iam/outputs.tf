output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster.arn
}

output "node_role_arn" {
  value = aws_iam_role.eks_nodes.arn
}

output "irsa_role_arns" {
  value = { for k, v in aws_iam_role.irsa : k => v.arn }
}
output "alb_controller_policy_arn" {
  value = aws_iam_policy.alb_controller.arn
}



