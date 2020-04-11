# terraform-aws-vpc
Terraform template for an AWS VPC

# How to use
Instanciate this module by calling it in a terraform file:

```HCL
module "vpc" {
    # source  = "codezenith/XX/XX"  // take source snippet from registry.terraform.io
    # version = "X.X.X"             // take version snippet from registry.terraform.io

    # COMMON
    profile = "my_profile"
    region  = "us-east-1"

    # VPC
    cidr_block          = "10.0.120.0/24"
    tenancy             = "default"
    dns_sup_hn          = true
    availability_zones  = [ "us-east-1a", "us-east-1b" ]
    vpc_tags            = {
        "Name"          = "MyVPC",
        "ProvisionedBy" = "Terraform"
    }

    # ENDPOINTS
    sn_pub_priv = "private"
    ep_priv_dns = true

    ep_if_list  = [
        "com.amazonaws./region/.logs",
        "com.amazonaws./region/.ssm",
        "com.amazonaws./region/.ecr.dkr"
    ]

    ep_gw_list  = [
        "com.amazonaws./region/.s3"
    ]

    # INTERNET GATEWAY && ROUTE TABLES
    enable_igw  = true

    # SECURITY GROUPS
    ingress_port = 443
    app_port     = 8080
    db_port      = 3306
}
```

For a definition of the expected format of variables, please see the Inputs section. The description and default variables provide examples.