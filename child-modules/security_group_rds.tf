
# create security group for RDS
resource "aws_security_group" "rds-sg" {
  name        = "${var.project_name}-rds-sg"
  description = "enable rds access on port 5432"
  vpc_id      = aws_vpc.e-learning.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules-rds
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
  }


  dynamic "egress" {
    iterator = port
    for_each = var.egressrules-rds
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}