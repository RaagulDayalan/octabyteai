# Infrastructure & Application Setup

This project has 3 parts:

---

## Part 1: Infrastructure Provisioning

- **Terraform is installed** and added to the system PATH
- Run `terraform init` to initialize
- `main.tf` has AWS provider and uses a credential profile with necessary access

### Modules Used
1. **VPC**
2. **EC2**
3. **RDS**

---

### VPC Module

- VPC has **4 subnets**:
  - 2 public (with internet gateway)
  - 2 private (routed through NAT gateway)

---

### EC2 Module

- A **bastion host** is created in a public subnet using Ubuntu AMI (from `tfvars`)
- Public subnet ID is taken from VPC module
- SSH key pair is created using AWS and the name is passed via `tfvars`
- **Security group** allows:
  - SSH (port 22)
  - PostgreSQL (for RDS access via local port forwarding)
  - Access is restricted to a single IP (e.g., office VPN)

#### Application Setup
- Setup: **Launch Template → ASG → Target Group → ALB**
- App server is in **private subnet**, SSH access only from bastion
- **Auto Scaling** based on CPU, starts with 2 instances
- Key pair for app server is already created, name passed through `tfvars`
- Instance type, AMI, and volume size all passed via `tfvars`
- **4 security groups** created:
  - bastion
  - app server
  - RDS
  - ALB
- ALB uses an ACM cert (ARN provided via `tfvars`)
- Optional: ALB access logging can be enabled using S3 module

---

### RDS Module

- Creates a **subnet group** using private subnets from VPC
- **PostgreSQL 13.7** is used
- Custom parameter group for Postgres13
- DB instance type comes from `tfvars`

---

## Part 2: Deployment Automation

- React app is deployed using **nginx Docker image**
- Dockerfile copies:
  - build folder
  - nginx config file
- Image is pushed to **AWS ECR**
- EC2 pulls image and runs it via SSH

---

## Part 3: Monitoring & Logging

- CloudWatch agent is installed:
  ```bash
  sudo apt install amazon-cloudwatch-agent -y
- The CloudWatch agent is configured to push:
   - CPU, memory, and disk usage
   - Nginx access logs
   - Nginx error logs
   - System logs (like /var/log/syslog, /var/log/auth.log)

A CloudWatch IAM role or user is created and attached to the EC2 instance profile
    (Alternatively, credentials can be placed in ~/.aws/credentials for testing)

Load Balancer (ALB) Metrics

- The application load balancer (ALB) automatically sends the following metrics to CloudWatch:
   - Request rate
   - Error rate
   - Latency
   - Request count
   - Target response code
   - Target response time

- RDS Monitoring
   - RDS sends default metrics like CPU, memory, DB connections, read/write throughput
   - Performance Insights is enabled for deeper analysis of database performance

- EC2 Metrics Dashboard

- A CloudWatch dashboard is created to visualize EC2 metrics:
   - CPU utilization
   - Memory usage
   - Disk space
   - Network IOPS
   - System logs and Nginx logs included in log groups

- ELB Metrics Dashboard

- Another dashboard is created for ALB (ELB) metrics:
   - Request count
   - ELB response status codes
   - Target response status codes
   - Target response time
   - Healthy host count

## Part 4: Documentation and Best Practices

### How to Set Up and Run the Infrastructure

1. **Install Terraform** and add it to your system's PATH environment variable
2. Run `terraform init` to initialize the configuration
3. Create a **Terraform IAM user** and add its credentials to your `~/.aws/credentials` file under a new profile
4. Run:
```bash
terraform plan --var-file="your-vars.tfvars"
terraform apply --var-file="your-vars.tfvars"
Type yes when prompted
Architecture Decisions
    Chose to deploy on EC2 for simplicity in Terraform setup
    Can be extended to ECS by adding
        Task definition
        ECS service
        ECS cluster

Security Considerations
    Attach AWS WAF to the ALB
    Use AWS-managed rule sets to protect against:
        Common web exploits
        SQL injection
        Bad bots, etc.

Cost Optimization Measures
    Use Reserved Instances for:
        EC2 (App + Bastion)
        RDS
    Scale-down unused resources in non-prod environments

Secret Management
    Use AWS Secrets Manager to securely store:
        RDS database username
        RDS database password
    Fetch them securely in your app or Terraform if needed
    
Backup Strategy
    Enable automated backups for RDS
    Setup cross-region backup replication as part of a disaster recovery (DR) plan