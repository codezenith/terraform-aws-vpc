output "subnets_public" {
  value = aws_subnet.subnet-public.*
}

output "subnets_private" {
  value = aws_subnet.subnet-private.*
}

output "sg_www" {
  value = aws_security_group.sg-www
}

output "vpc" {
  value = aws_vpc.vpc
}

output "sg_app" {
  value = aws_security_group.sg-app
}

output "sg_db" {
  value = aws_security_group.sg-db
}

output "sg_ep" {
  value = aws_security_group.sg-ep
}

output "sg_ep_client" {
  value = aws_security_group.sg-ep-client
}