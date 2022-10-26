output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet" {
  value = [aws_subnet.private_subnet["Private1"].id, aws_subnet.private_subnet["Private2"].id]
}

output "public_subnet" {
  value = [aws_subnet.public_subnet["Public1"].id, aws_subnet.public_subnet["Public2"].id]
}

output "igw" {
  value = aws_internet_gateway.igw.id
}