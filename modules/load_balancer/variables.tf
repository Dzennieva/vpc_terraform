variable "project_name" {
  description = "Name of the project"
  type        = string 
}

variable "vpc_id" {
  description = "ID of the VPC to which the security groups will be applied"
  type        = string
  
}
variable "alb_sg_id" {  
  description = "ID of the security group for the Application Load Balancer"
  type        = string

}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
  
}
variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
  
}

variable "public_subnets_ids" {
  description = "List of public subnet IDs for the Application Load Balancer"
  type        = list(string)
  
}