output "private-subnet-a" {
  value = aws_subnet.private-subnet-a.id
}

output "private-subnet-b" {
  value = aws_subnet.private-subnet-b.id
}

output "EKS-Cluster-SG" {
  value = aws_security_group.EKS-Cluster-SG.id
}