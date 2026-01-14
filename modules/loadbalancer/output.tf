output load-balancer-target-group-arn {
    value = aws_lb_target_group.load-balancer-target-group.arn
}

output "target_group_name" {
  value = aws_lb_target_group.load-balancer-target-group.name
}

output "load_balancer_output" {
  value = local.lb_dns_name
}