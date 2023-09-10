
# create security group for ECS and ALB
resource "aws_security_group" "webserver_security_group" {
  name        = "${var.project_name}-webserver-sg"
  description = "enable http or https access on port 80 or 443"
  vpc_id      = aws_vpc.e-learning.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
  }


  dynamic "egress" {
    iterator = port
    for_each = var.egressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-webserver security group"
  }
}