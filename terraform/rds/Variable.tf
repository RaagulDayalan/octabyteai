variable "subnet_ids" {
  description = "List of subnet IDs for EC2 instances"
  type        = list(string)
}
variable "infra_prefix" {
  type = string
}
variable "db_instnace_type" {
  type        = string
}

variable "ec2_rds_sg" {
  type        = string
}

variable "SECRET" {
  type        = string
  sensitive   = true
}

