# AWS VPC Infrastructure with Terraform

This repository contains Terraform configurations to provision a highly available, scalable, and secure Virtual Private Cloud (VPC) infrastructure on Amazon Web Services (AWS). It includes public and private subnets across multiple Availability Zones, an Application Load Balancer (ALB), an Auto Scaling Group (ASG) for EC2 instances, and a simple Python Flask application deployed to demonstrate functionality.

## 🚀 Project Overview

This project aims to demonstrate the deployment of a foundational AWS network environment capable of hosting a scalable web application. It showcases best practices in Infrastructure as Code (IaC), cloud networking, and automated application deployment.

### Architecture Diagram (Conceptual)
<pre>+-------------------------------------------------------------------------------------------------------+
| AWS Region (us-east-1)                                                                          |
|                                                                                                       |
| +---------------------------------------------------------------------------------------------------+ |
| | VPC (10.0.0.0/16)                                                                                 | |
| |                                                                                                   | |
| | +---------------------+     +---------------------+                                             | |
| | | Internet Gateway    |-----| Public Route Table  |                                             | |
| | +---------------------+     +---------------------+                                             | |
| |                                                                                                   | |
| | AZ-1 (us-east-1a)          AZ-2 (us-east-1b)                                          | |
| | +--------------------------+   +--------------------------+                                       | |
| | | Public Subnet 1          |   | Public Subnet 2          |                                       | |
| | | (10.0.1.0/24)              |   | (10.0.2.0/24)              |                                       | |
| | |                            |   |                            |                                       | |
| | | +----------------------+   |   | +----------------------+   |                                       | |
| | | | Application Load     |   |   | | Application Load     |   |                                       | |
| | | | Balancer (ALB)       |   |   | | Balancer (ALB)       |   |                                       | |
| | | +----------------------+   |   | +----------------------+   |                                       | |
| | |                            |   |                            |                                       | |
| | | +----------------------+   |   | +----------------------+   |                                       | |
| | | | NAT Gateway 1        |   |   | | NAT Gateway 2        |   |                                       | |
| | | +----------------------+   |   | +----------------------+   |                                       | |
| | +--------------------------+   +--------------------------+                                       | |
| |           |                        |                                                              | |
| |           | (Traffic to ALB)       | (Traffic to ALB)                                             | |
| |           |                        |                                                              | |
| | +--------------------------+   +--------------------------+                                       | |
| | | Private Subnet 1         |   | Private Subnet 2         |                                       | |
| | | (10.0.2.0/24)            |   | (10.0.3.0/24)            |                                       | |
| | |                            |   |                            |                                       | |
| | | +----------------------+   |   | +----------------------+   |                                       | |
| | | | EC2 Instance (ASG)   |   |   | | EC2 Instance (ASG)   |   |                                       | |
| | | | (Python App)         |   |   | | (Python App)         |   |                                       | |
| | | +----------------------+   |   | +----------------------+   |                                       | |
| | +--------------------------+   +--------------------------+                                       | |
| |           ^                        ^                                                              | |
| |           | (Outbound via NAT GW)  | (Outbound via NAT GW)                                        | |
| |           |                        |                                                              | |
| | +---------------------+     +---------------------+                                             | |
| | | Private Route Table |-----| NAT Gateway         |                                             | |
| | +---------------------+     +---------------------+                                             | |
| +---------------------------------------------------------------------------------------------------+ | ``` </pre>
## ✨ Features

- **Multi-AZ Deployment:** Infrastructure spans two Availability Zones for high availability.
- **Segregated Networking:** Public and private subnets for secure resource placement.
- **Internet Connectivity:** Internet Gateway for public subnet access and NAT Gateways for secure outbound access from private subnets.
- **Load Balancing:** Application Load Balancer (ALB) to distribute incoming HTTP traffic.
- **Auto Scaling:** Auto Scaling Group (ASG) to dynamically manage EC2 instance count based on demand.
- **Security Best Practices:** Granular Security Groups for ALB and EC2 instances, and IAM Roles for secure instance permissions.
- **Automated Deployment:** EC2 instances are bootstrapped with a Python Flask application using user data scripts.
- **Modular Terraform:** Organized into reusable modules for VPC, Security Groups, EC2/ASG, and Load Balancer.

## 💻 Technologies Used

- **Infrastructure as Code (IaC):** Terraform
- **Cloud Provider:** AWS
- **VPC (Virtual Private Cloud)**
- **EC2 (Elastic Compute Cloud)**
- **ALB (Application Load Balancer)**
- **ASG (Auto Scaling Group)**
- **IAM (Identity and Access Management)**
- **Security Groups**
- **NAT Gateway**
- **Elastic IP (EIP)**
- **Route Tables**
- **Programming Language:** Python (Flask)
- **Scripting:** Bash (for user data)

## 📋 Prerequisites

Before deploying this project, ensure you have the following:

- **AWS Account:** An active AWS account.

- **AWS CLI:** Installed and configured with credentials that have sufficient permissions to create VPC, EC2, ALB, ASG, and IAM resources.

- **Terraform:** Installed locally (version 1.0+ recommended).

- **EC2 Key Pair:** An existing EC2 Key Pair in your chosen AWS region. This is essential for SSH access to your instances for debugging or management.

## 📂 Project Structure
The repository is structured to promote modularity and readability:

<pre>
.
├── main.tf                 # Root module: Orchestrates other modules
├── variables.tf            # Root module: Global variables for the project
├── outputs.tf              # Root module: Outputs from the entire deployment (e.g., ALB DNS name)
├── scripts/                # Directory for shell scripts
│   └── install_app.sh      # Script to install Python, Flask, Gunicorn, and run the app
└── modules/                # Directory for reusable Terraform modules
    ├── vpc/                # Defines VPC, subnets, IGW, NAT GW, route tables
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security_groups/    # Defines Security Groups for ALB and Web Servers
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── ec2_asg/            # Defines EC2 Launch Template, ASG, IAM role/profile
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── load_balancer/      # Defines ALB, Target Group, and Listener
        ├── main.tf
        ├── variables.tf
        └── outputs.tf </pre> 
## 🚀 Deployment Steps
1. **Clone the Repository:**

<pre>git clone https://github.com/Dzennieva/vpc_terraform.git
cd vpc_terraform </pre>

2. **Configure Variables:**
Open variables.tf in the root directory and update the following:

- ```aws_region```: Set your desired AWS region (e.g., "us-east-1").

- ```ami_id```: Replace the default with a valid AMI ID for your chosen region and desired OS (e.g.,Ubuntu). You can find this in the EC2 console or using the AWS CLI.

- ```key_name```: Replace "your-key-pair-name" with the actual name of your EC2 Key Pair.

  - Review and adjust other variables (e.g., ```vpc_cidr```, ```azs```, ```instance_type```) as needed.

3. **Initialize Terraform:**
Navigate to the root of the project in your terminal and run:


 <pre> ```bash terraform init```</pre>

This command downloads the necessary AWS provider and initializes the modules.

4. **Review the Plan:**
To see exactly what Terraform will create, modify, or destroy, run:

<pre> ```bash terraform plan```</pre>

Review the output carefully to ensure it aligns with your expectations.

5. **Apply the Configuration:**
If the plan looks good, apply the configuration to provision the resources in your AWS account:

<pre> ```bash terraform apply ```</pre>

Type ```yes``` when prompted to confirm the deployment.

6. **Access the Application:**
Once terraform apply completes, Terraform will output the DNS name of your Application Load Balancer.

#### Outputs:

<pre> ```bash alb_dns_name = "your-alb-dns-name.us-east-1.elb.amazonaws.com"```</pre>


Copy the ```alb_dns_name``` value and paste it into your web browser. You should see the "Hello from Flask app on instance: [hostname]!" message.

## 🐍 Application Details
A simple Python Flask application is deployed on the EC2 instances:

```app.py:```

<pre>```python
from flask import Flask
import socket

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = socket.gethostname()
    return f"Hello from Flask app on instance: {hostname}!"

if __name__ == '__main__':
    pass # Gunicorn will manage the server ```</pre>


##  📈 Future Enhancements
This project provides a solid foundation. Consider these enhancements to further develop your skills:

- **Database Integration:** Add an AWS RDS database (e.g., PostgreSQL or MySQL) in a private subnet.

- **HTTPS Enablement:** Implement HTTPS for the ALB using AWS Certificate Manager (ACM).

- **Dynamic Scaling Policies:** Configure aws_autoscaling_policy resources based on CloudWatch metrics (e.g., CPU utilization) for more dynamic scaling.

- **CI/CD Pipeline:** Integrate this Terraform project and the Python application into a CI/CD pipeline (e.g., using GitHub Actions, AWS CodePipeline).

- **Logging & Monitoring:** Set up CloudWatch Logs, Alarms, and potentially integrate with external monitoring tools.

- **Containerization:** Migrate the Flask application to Docker containers and deploy on Amazon ECS or EKS.

## 🗑️ Cleaning Up
To destroy all the resources created by this Terraform configuration (and avoid incurring AWS costs), navigate to the root of the project in your terminal and run:

<pre> ```bash terraform destroy``` </pre>

Type ```yes``` when prompted to confirm the destruction.
