resource "aws_db_subnet_group" "priv_sub_grp" {
  name       = "${var.infra_prefix}-private-sub-grp"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "${var.infra_prefix}-private-sub-grp"
    
    
  }
}

resource "aws_db_parameter_group" "custom-rds-parameter-group" {
  name   = "${var.infra_prefix}-rds-pg"
  family = "postgres13"
  tags = {
    Name = "${var.infra_prefix}-private-sub-grp"
    
    
  }
}


resource "aws_db_instance" "example" {
  allocated_storage = 50
  max_allocated_storage = 100
  storage_type = "gp3"
  engine                 = "postgres"
  engine_version         = "13.7"
  instance_class = var.db_instnace_type
  final_snapshot_identifier="${var.infra_prefix}-db-snapshot"
  parameter_group_name = aws_db_parameter_group.custom-rds-parameter-group.name
  performance_insights_enabled = true
  publicly_accessible = false
  skip_final_snapshot = true
  backup_retention_period     = 7
  db_subnet_group_name        = aws_db_subnet_group.priv_sub_grp.name
  identifier                  = "${var.infra_prefix}-db"
  multi_az                    = false
  apply_immediately                     = true
  password                    = var.SECRET
  storage_encrypted           = true
  username                    = "${var.infra_prefix}"
  vpc_security_group_ids = [var.ec2_rds_sg] 
  tags = {
    Name = "${var.infra_prefix}-private-sub-grp"
    
    
  }
}