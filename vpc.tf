# creating a VPC with a  CIDR block and enabling DNS hostnames

resource "aws_vpc" "main" { # this lines 3-14 create a VPC
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = merge(
    var.vpc_tags,   # this allows other users to specify their own tags for the VPC
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}" # Name of the VPC roboshop-dev
    }
  )
}

resource "aws_internet_gateway" "main" { # this lines 16-22 create an Internet Gateway
  vpc_id = aws_vpc.main.id               # automatically attach the Internet Gateway to the VPC

  tags = merge(
    var.igw_tags,   # this allows other users to specify their own tags for the Internet Gateway
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}" # Name of the Internet Gateway roboshop-dev
    }
  )
}

#roboshop-dev-us-east-1a-public
#roboshop-dev-us-east-1-public
resource "aws_subnet" "public" {                            # this lines 27-38 create public subnets
  count                   = length(var.public_subnet_cidrs) # create multiple public subnets based on the provided CIDR blocks
  vpc_id                  = aws_vpc.main.id            # associate the subnet with the VPC created above
  cidr_block              = var.public_subnet_cidrs[count.index] # use the CIDR block from the list based on the index
  availability_zone       = local.az_names[count.index]          # assign the availability zone based on the index first two AZs like 1a , 1b
  map_public_ip_on_launch = true                                 # enable internet for public IP assignment for instances launched in this subnet

  tags = merge(
    var.public_subnet_tags, # this allows other users to specify their own tags for the public subnets
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-${local.az_names[count.index]}-public" # Name of the public subnet roboshop-dev-us-east-1a-public
    }
  )
}

#roboshop-dev-us-east-1a-private
#roboshop-dev-us-east-1b-private
resource "aws_subnet" "private" {                            # this lline 44-55 create private subnets
  count                   = length(var.private_subnet_cidrs) # create multiple private subnets based on the provided CIDR blocks
  vpc_id                  = aws_vpc.main.id            # associate the subnet with the VPC created above
  cidr_block              = var.private_subnet_cidrs[count.index] # use the CIDR block from the list based on the index
  availability_zone       = local.az_names[count.index]          # assign the availability zone based on the index first two AZs like 1a , 1b

  tags = merge(
    var.private_subnet_tags, # this allows other users to specify their own tags for the private subnets
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-${local.az_names[count.index]}-private" # Name of the private subnet roboshop-dev-us-east-1a-private
    }
  )
}

#roboshop-dev-us-east-1a-database
#roboshop-dev-us-east-1b-database
resource "aws_subnet" "database" {                            # this lline 44-55 create database subnets
  count                   = length(var.database_subnet_cidrs) # create multiple database subnets based on the provided CIDR blocks
  vpc_id                  = aws_vpc.main.id            # associate the subnet with the VPC created above
  cidr_block              = var.database_subnet_cidrs[count.index] # use the CIDR block from the list based on the index
  availability_zone       = local.az_names[count.index]          # assign the availability zone based on the index first two AZs like 1a , 1b

  tags = merge(
    var.database_subnet_tags, # this allows other users to specify their own tags for the database subnets
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-${local.az_names[count.index]}-database" # Name of the database subnet roboshop-dev-us-east-1a-database
    }
  )
}