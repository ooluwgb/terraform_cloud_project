resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

# Ingress rules
resource "aws_security_group_rule" "ingress" {
  count             = length(var.ingress_rules)
  type              = "ingress"
  from_port         = var.ingress_rules[count.index].from_port
  to_port           = var.ingress_rules[count.index].to_port
  protocol          = var.ingress_rules[count.index].protocol
  cidr_blocks       = lookup(var.ingress_rules[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks  = lookup(var.ingress_rules[count.index], "ipv6_cidr_blocks", null)
  security_group_id = aws_security_group.this.id
}

# Egress rules
resource "aws_security_group_rule" "egress" {
  count             = length(var.egress_rules)
  type              = "egress"
  from_port         = var.egress_rules[count.index].from_port
  to_port           = var.egress_rules[count.index].to_port
  protocol          = var.egress_rules[count.index].protocol
  cidr_blocks       = lookup(var.egress_rules[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks  = lookup(var.egress_rules[count.index], "ipv6_cidr_blocks", null)
  security_group_id = aws_security_group.this.id
}
