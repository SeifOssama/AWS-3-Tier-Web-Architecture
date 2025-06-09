output "frontend_target_group" {
  value = aws_lb_target_group.frontend_target_group.arn
}

output "backend_target_group" {
  value = aws_lb_target_group.backend_target_group.arn
}

output "backend_alb_dns" {
  value = aws_lb.backend_alb.dns_name
}

output "front_alb_dns" {
  value = aws_lb.frontend_alb.dns_name
}