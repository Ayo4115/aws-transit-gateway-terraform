output "ec2_vpc1_public_ip" { value = aws_instance.ec2_1.public_ip }
output "ec2_vpc2_public_ip" { value = aws_instance.ec2_2.public_ip }
output "ec2_vpc3_public_ip" { value = aws_instance.ec2_3.public_ip }
output "tgw_id" { value = aws_ec2_transit_gateway.tgw.id }
