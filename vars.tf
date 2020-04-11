# COMMON

variable "profile" {
  type        = string
  description = "AWS Profile to use"
}

variable "region" {
  type        = string
  description = "AWS region to deploy into"
}



# VPC

variable "cidr_block" {
  type        = string
  description = "CIDR Block for the VPC (e.g.: 10.223.3.0/24)"
}

variable "tenancy" {
  type        = string
  description = "Hardware Tenancy (default, dedicated)"
}

variable "dns_sup_hn" {   # enable dns_support and dns_hostnames
  type        = bool
  description = "Private DNS and Private Hostname support"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones (e.g.: [ eu-central-1a, eu-central-1b ])"
}

variable "vpc_tags" {
  type        = map
  description = "Tags to propagate to the vpc"
  default     = {
    "Name"          = "MyVPC",
    "ProvisionedBy" = "Terraform"
  }
}


# ENDPOINTS

variable "ep_if_list" {
  type        = list(string)
  description = "List of Interface endpoints to enable, Leave empty for no enpoints. Insert region as '/region/' as it will be interpolated at runtime"
  default     = [
    "com.amazonaws./region/.logs",
    "com.amazonaws./region/.ecr.dkr",
    "com.amazonaws./region/.ssm",
    "com.amazonaws./region/.ssmmessages"
  ]
}

variable "sn_pub_priv" {
  type        = string
  description = "Associate the enpoints with public or private subnets? Explicit 'private' for private, else public"
  default     = "private"
}

variable "ep_priv_dns" {
  type        = bool
  description = "Enable private DNS for the endpoints?"
}


variable "ep_gw_list" {
  type        = list(string)
  description = "List of Gateway endpoints to enable, Leave empty for no enpoints. Insert region as '/region/' as it will be interpolated at runtime"
  default     = [
    "com.amazonaws./region/.s3"
  ]
}


# INTERNET GATEWAY && ROUTE TABLES

variable "enable_igw" {
  type        = bool
  description = "Create an internet gateway?"
}


# SECURITY GROUPS

variable "ingress_port" {
  type        = number
  description = "Ingress port from outside AWS VPC (e.g.: 443 or 8080)"
}

variable "app_port" {
  type        = number
  description = "Application ingress port. Ingress is allowed from sg_www"
}

variable "db_port" {
  type        = number
  description = "Database ingress port. Ingress is allowed from sg_app"
}
