resource "aws_security_group" "sg-www" {
  name        = "sg_www"
  description = "Ingress from www to VPC"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol        = "TCP"
    from_port       = var.ingress_port
    to_port         = var.ingress_port
    cidr_blocks     = [ "0.0.0.0/0" ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "sg-app" {
  name        = "sg_app"
  description = "Application security group."
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol        = "TCP"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [ aws_security_group.sg-www.id ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "sg-ep" {
  count       = (length(var.ep_if_list) + length(var.ep_gw_list)) == 0 ? 0 : 1
  name        = "sg_ep"
  description = "VPC Endopoint security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol        = "TCP"
    from_port       = 443
    to_port         = 443
    security_groups = [ aws_security_group.sg-ep-client[count.index].id ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "sg-ep-client" {
  count       = (length(var.ep_if_list) + length(var.ep_gw_list)) == 0 ? 0 : 1
  name        = "sg_ep_client"
  description = "Client security group for accessing the endpoints"
  vpc_id      = aws_vpc.vpc.id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "sg-db" {
  name        = "sg_db"
  description = "Database security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol        = "TCP"
    from_port       = var.db_port
    to_port         = var.db_port
    security_groups = [ aws_security_group.sg-app.id ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}