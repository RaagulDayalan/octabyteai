output "ec2_rds_sg" {
  description = "ec2 rds sg"
  value = aws_security_group.rds_sg.id
}