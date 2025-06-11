variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  
}

variable "key_name" {
  description = "Name of the key pair for SSH access to the EC2 instances"
  type        = string
  
}

variable "vpc_id" {
  description = "ID of the VPC to which the security groups will be applied"
  type        = string
  
}

variable "ec2_sg_id" {
  description = "ID of the security group for the EC2 instances"
  type        = string  
}

variable "user_data_script" {
  description = "User data script for the EC2 instances"
  type        = string 
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the Auto Scaling Group"
  type        = list(string)
  
}

variable "asg_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number

  
}
variable "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number

  
}
