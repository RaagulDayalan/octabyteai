resource "aws_security_group" "rds_sg" {
  name        = "${var.infra_prefix}-rds-SG"
  description = "${var.infra_prefix}-rds-SG"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups= [aws_security_group.ec2_bastion_sg.id]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups= [aws_security_group.ec2_app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [ aws_security_group.ec2_bastion_sg, aws_security_group.ec2_app_sg  ]
}

resource "aws_security_group" "ec2_bastion_sg" {
  name        = "${var.infra_prefix}-ec2-bastion-SG"
  description = "${var.infra_prefix}-ec2-bastion-SG"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks= [var.office_ip]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks= [var.office_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_app_sg" {
  name        = "${var.infra_prefix}-ec2-app-SG"
  description = "${var.infra_prefix}-ec2-app-SG"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups =  [aws_security_group.ec2_bastion_sg.id]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups= [aws_security_group.ec2_app_lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [  aws_security_group.ec2_app_lb_sg ]
}




resource "aws_security_group" "ec2_app_lb_sg" {
  name        = "${var.infra_prefix}-ec2-app-lb-SG"
  description = "${var.infra_prefix}-ec2-app-lb-SG"
  vpc_id      = var.vpc_id
  
   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
