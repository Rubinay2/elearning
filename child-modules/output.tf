# VPC variables
output "vpc_id" {
  value = aws_vpc.e-learning.id
}

/*output "vpc_cidr" {
  value = aws_vpc.e-learning.vpc_cidr
}
*/