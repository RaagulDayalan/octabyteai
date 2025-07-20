variable "infra_prefix" {
  type = string
}
variable "ami_id" {
  type = string
}
variable "instance_type" {
  type = string
}

variable "instance_volume" {
  type = string
}
variable "subnet_ids" {
  description = "List of subnet IDs for EC2 instances"
  type        = list(string)
}
variable "iam_ec2_cw_role" {
  description = "iam role for ec2 cw"
  type        = string
}
variable "vpc_id" {
  description = "vpc id"
  type        = string
}
variable "app_domain_cert" {
  description = "wec domain cert"
  type        = string
}

variable "office_ip" {
  description = "office ip"
  type        = string
}
variable "public_subnet" {
  description = "public sub"
  type        = string
}

variable "bastion_key_file" {
  description = "bastion_key_file"
  type        = string
}
variable "application_key_file" {
  description = "application_key_file"
  type        = string
}

