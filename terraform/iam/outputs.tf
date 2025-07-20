output "iam_ec2_cw_role" {
  description = "iam ec2 cw role"
  value = aws_iam_role.ec2_cw_role.name
}