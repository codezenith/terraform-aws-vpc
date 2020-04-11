# SEE: https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "vpc" {
  cidr_block            = var.cidr_block
  instance_tenancy      = var.tenancy
  
  enable_dns_support    = var.dns_sup_hn
  enable_dns_hostnames  = var.dns_sup_hn

  tags = var.vpc_tags
}


resource "aws_subnet" "subnet-public" {
  count      = length(var.availability_zones)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(
                var.cidr_block,
                ceil(log(length(var.availability_zones) * 2, 2)),
                (count.index)
               )

  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "subnet-public-${count.index}"
  }
}

resource "aws_subnet" "subnet-private" {
  count      = length(var.availability_zones)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(
                var.cidr_block,
                ceil(log(length(var.availability_zones) * 2, 2)),
                (count.index + length(var.availability_zones))
               )

  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "subnet-private-${count.index}"
  }
}


#com.amazonaws.eu-central-1.ssm
#com.amazonaws.eu-central-1.ssmmessages

resource "aws_vpc_endpoint" "ep-if" {
  count             = length(var.ep_if_list)
  vpc_id            = aws_vpc.vpc.id
  service_name      = replace(var.ep_if_list[count.index], "/region/", var.region)
  vpc_endpoint_type = "Interface"

  security_group_ids = [ aws_security_group.sg-ep[count.index].id ]
  subnet_ids         = var.sn_pub_priv == "private" ? aws_subnet.subnet-private.*.id : aws_subnet.subnet-private.*.id

  private_dns_enabled = var.ep_priv_dns
}


resource "aws_vpc_endpoint" "ep-gw" {
  count             = length(var.ep_gw_list)
  vpc_id            = aws_vpc.vpc.id
  service_name      = replace(var.ep_gw_list[count.index], "/region/", var.region)
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [ aws_route_table.route-ep[count.index].id ]
}


resource "aws_internet_gateway" "igw" {
  count  = var.enable_igw == true ? 1 : 0
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route" {
  count  = var.enable_igw == true ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[count.index].id
  }
}

resource "aws_route_table_association" "rt-assoc-gw" {
  count          = var.enable_igw == true ? length(aws_subnet.subnet-public) : 0
  subnet_id      = aws_subnet.subnet-public[ count.index ].id
  route_table_id = aws_route_table.route[count.index].id
}


resource "aws_route_table" "route-ep" {
  count  = var.enable_igw == true ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "rt-assoc" {
  count          = var.enable_igw == true ? length(aws_subnet.subnet-private) : 0
  subnet_id      = aws_subnet.subnet-private[ count.index ].id
  route_table_id = aws_route_table.route-ep[count.index].id
}