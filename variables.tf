variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "vpc_tags" { # Tags for the VPC for other user creates there own tags
  type    = map(string)
  default = {}
}

variable "igw_tags" { # Tags for the Internet Gateway for other user creates there own tags
  type    = map(string)
  default = {}
}

variable "public_subnet_cidrs" { # List of CIDR blocks for public subnets
  type = list(string)
}

variable "public_subnet_tags" { # Tags for the public subnets for other user creates there own tags
  type    = map(string)
  default = {}
}

variable "private_subnet_cidrs" { # List of CIDR blocks for private subnets
  type = list(string)
}

variable "private_subnet_tags" { # Tags for the private subnets for other user creates there own tags
  type    = map(string)
  default = {}
}

variable "database_subnet_cidrs" { # List of CIDR blocks for database subnets
  type = list(string)
}

variable "database_subnet_tags" { # Tags for the database subnets for other user creates there own tags
  type    = map(string)
  default = {}
}

variable "eip_tags" {
  type = map(string)
  default = {}
}

variable "nat_gateway_tags" {
  type    = map(string)
  default = {}
}

variable "public_route_table_tags" { # Tags for the public route table for other user creates there own tags
  type    = map(string)
  default = {}
}

variable "private_route_table_tags" { # Tags for the private route table for other user creates there own tags
  type    = map(string)
  default = {}
}

variable "database_route_table_tags" { # Tags for the database route table for other user creates there own tags
  type    = map(string)
  default = {}
}