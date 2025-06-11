output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.web_alb.dns_name
  
}

output "target_group_arn" {
  description = "The ARN of the Target Group."
  value       = aws_lb_target_group.web_alb_tg.arn
}