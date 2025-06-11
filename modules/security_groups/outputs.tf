

output "alb_sg_id" {
  description = "The ID of the security group for the load balancer"
  value       = aws_security_group.alb_sg.id
  
}

output "ec2_sg_id" {
  description = "The ID of the security group for the EC2 instances"
  value       = aws_security_group.ec2_sg.id
  
}