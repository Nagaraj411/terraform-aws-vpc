# creating a VPC with a  CIDR block and enabling DNS hostnames

resource "aws_vpc" "main" {  # this lines 3-14 create a VPC
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}" # Name of the VPC roboshop-dev
    }
  )
}

resource "aws_internet_gateway" "main" {  # this lines 16-22 create an Internet Gateway
  vpc_id = aws_vpc.main.id  # automatically attach the Internet Gateway to the VPC

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}" # Name of the Internet Gateway roboshop-dev
    }
  )
} 