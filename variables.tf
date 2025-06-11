
variable "project_name" {
  description = "Name of the project"
  type        = string
  default = "Jun"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones for the VPC"
  type        = list(string)
  default = ["us-east-1a", "us-east-1b"]
  
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default = "ami-0731becbf832f281e"
  
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default = "t2.micro"
  
}

variable "key_name" {
  description = "Name of the key pair for SSH access to the EC2 instances"
  type        = string
  default = "temi"
}

variable "asg_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default = 1
  
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default = 3
  
}
variable "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default = 2
}
  
variable "app_port" {
  description = "The port on which the Python application listens."
  type        = number
  default     = 8080
}

