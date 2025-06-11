variable "vpc_id" {
  description = "ID of the VPC to which the security groups will be applied"
  type        = string  
}


variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "app_port" {
  description = "Port for the target group"
  type        = number
}