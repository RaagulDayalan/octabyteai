
resource "aws_instance" "template_bastion" {
  ebs_block_device {
      device_name = "/dev/sdf"
      volume_size = var.instance_volume
      delete_on_termination=true
  }
  subnet_id     = var.public_subnet
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.bastion_key_file
  
  associate_public_ip_address = true
  security_groups = [aws_security_group.ec2_bastion_sg.id]

  tags = {
    Name = "${var.infra_prefix}-bastion"
    
    
  }

  depends_on = [ aws_security_group.ec2_bastion_sg ]
}
