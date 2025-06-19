# creating a VPC with a  CIDR block and enabling DNS hostnames

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}" # Name of the VPC
    }
  )
}