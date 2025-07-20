variable "infra_prefix" {
  type = string
}
variable "availability_zone_1" {
  type = string
}
variable "availability_zone_2" {
  type = string
}
variable "ami_id" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "iam_ec2_cw_role" {
  description = "iam role for ec2 cw"
  type        = string
}
variable "instance_volume" {
  type = string
}
variable "app_domain_cert" {
  type = string
}

variable "office_ip" {
type        = string
}
variable "db_instnace_type" {
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

variable "SECRET" {
  description = "SECRET"
  type        = string
  sensitive   = true
}
