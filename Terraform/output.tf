output "backend_alb_dns" {
  value = module.ALB.backend_alb_dns
}

output "front_alb_dns" {
  value = module.ALB.front_alb_dns
}

output "db_endpoint" {
  value = module.rds_db.db_endpoint
}

output "rendered_user_data" {
 value = templatefile("${path.module}/modules/ASG/UserData/frontend.sh.tpl", {
 backend_alb_dns = module.ALB.backend_alb_dns
 })
}