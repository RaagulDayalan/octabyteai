resource "aws_launch_template" "template_app_LT" {
  name = "${var.infra_prefix}-LT"
  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = var.instance_volume
      delete_on_termination=true
    }
  }
  image_id = var.ami_id
  instance_type = var.instance_type
  key_name = var.application_key_file
  iam_instance_profile {
    name = aws_iam_instance_profile.iam_ec2_cw_profile.name
  }
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = false
    security_groups=[aws_security_group.ec2_app_sg.id]
  }
  //vpc_security_group_ids = [aws_security_group.ec2_app_sg.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.infra_prefix}-LT"
          
    
    }
  }
  depends_on = [ aws_security_group.ec2_app_sg ]
}

resource "aws_iam_instance_profile" "iam_ec2_cw_profile" {
  name = "iam-ec2-cw-role"
  role = var.iam_ec2_cw_role
}
