

# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = var.database-subnets
  subnet_ids  = [aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id]
  description = "subnets for database instance"

  tags = {
    Name = "database-subnets"
  }
}


# create the rds instance
resource "aws_db_instance" "db_instance" {
  engine                 = var.engine
  engine_version         = var.engine_version
  multi_az               = false
  identifier             = "dev-rds-instance"
  username               = var.username
  password               = var.password
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  availability_zone      = data.aws_availability_zones.eaz.names[0]
  db_name                = var.db_name
  skip_final_snapshot    = var.skip_final_snapshot
}

