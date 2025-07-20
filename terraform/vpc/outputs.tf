output "subnet_ids" {
  description = "List of priv subnet IDs"
  value = [
    aws_subnet.template_priv_sub1.id,
    aws_subnet.template_priv_sub2.id
  ]
}
output "vpc_id" {
  description = "vpc id"
  value = aws_vpc.template_vpc.id
}
output "public_subnet" {
  description = "public_subnet"
  value = aws_subnet.template_pub_sub2.id
}