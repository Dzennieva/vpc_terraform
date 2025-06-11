output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "lb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.load_balancer.dns_name
}

output "app_url" {
  description = "The URL of the application"
  value       = "http://${module.load_balancer.dns_name}"
  
}