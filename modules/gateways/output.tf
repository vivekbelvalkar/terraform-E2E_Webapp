output "NATgw_id"{
    value = aws_nat_gateway.NATgw.id
}

output "igw_id"{
    value = aws_internet_gateway.igw.id
}