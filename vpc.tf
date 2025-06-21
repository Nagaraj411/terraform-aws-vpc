# creating a VPC with a  CIDR block and enabling DNS hostnames

resource "aws_vpc" "main" { # this lines 3-15 create a VPC
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = merge(
    var.vpc_tags, # this allows other users to specify their own tags for the VPC
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}" # Name of the VPC roboshop-dev
    }
  )
}

resource "aws_internet_gateway" "main" { # this lines 16-27 create an Internet Gateway
  vpc_id = aws_vpc.main.id               # automatically attach the Internet Gateway to the VPC

  tags = merge(
    var.igw_tags, # this allows other users to specify their own tags for the Internet Gateway
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}" # Name of the Internet Gateway roboshop-dev
    }
  )
}

#roboshop-dev-us-east-1a-public
#roboshop-dev-us-east-1-public
resource "aws_subnet" "public" {                                 # this lines 31-45 create public subnets
  count                   = length(var.public_subnet_cidrs)      # create multiple public subnets based on the provided CIDR blocks
  vpc_id                  = aws_vpc.main.id                      # associate the subnet with the VPC created above
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
resource "aws_subnet" "private" {                           # this lline 49-62 create private subnets
  count             = length(var.private_subnet_cidrs)      # create multiple private subnets based on the provided CIDR blocks
  vpc_id            = aws_vpc.main.id                       # associate the subnet with the VPC created above
  cidr_block        = var.private_subnet_cidrs[count.index] # use the CIDR block from the list based on the index
  availability_zone = local.az_names[count.index]           # assign the availability zone based on the index first two AZs like 1a , 1b

  tags = merge(
    var.private_subnet_tags, # this allows other users to specify their own tags for the private subnets
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-${local.az_names[count.index]}-private" # Name of the private subnet roboshop-dev-us-east-1a-private
    }
  )
}

# #roboshop-dev-us-east-1a-database
# #roboshop-dev-us-east-1b-database
resource "aws_subnet" "database" {                           # this lline 66-79 create database subnets
  count             = length(var.database_subnet_cidrs)      # create multiple database subnets based on the provided CIDR blocks
  vpc_id            = aws_vpc.main.id                        # associate the subnet with the VPC created above
  cidr_block        = var.database_subnet_cidrs[count.index] # use the CIDR block from the list based on the index
  availability_zone = local.az_names[count.index]            # assign the availability zone based on the index first two AZs like 1a , 1b

  tags = merge(
    var.database_subnet_tags, # this allows other users to specify their own tags for the database subnets
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-${local.az_names[count.index]}-database" # Name of the database subnet roboshop-dev-us-east-1a-database
    }
  )
} 

# Create a elastic IP for the NAT Gateway
resource "aws_eip" "nat" { # this lines 82-91 create an Elastic IP for the NAT Gateway
  domain = "vpc"
  tags = merge(
    var.eip_tags, # this allows other users to specify their own tags for the Elastic IP
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}" # Name of the Elastic IP roboshop-dev
    }
  )
}

# creating a NAT Gateway to allow instances in private subnets to access the internet
resource "aws_nat_gateway" "main" { # this lines 94-107 create a NAT Gateway
  allocation_id = aws_eip.nat.id # associate the Elastic IP with the NAT Gateway
  subnet_id     = aws_subnet.public[0].id # place the NAT Gateway in the first public subnet

  tags = merge(
    var.nat_gateway_tags, # this allows other users to specify their own tags for the NAT Gateway
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-nat-gateway" # Name of the NAT Gateway roboshop-dev-nat-gateway
    }
  )
# This ensures that the NAT Gateway is created after the Internet Gateway and Elastic IP
  depends_on = [ aws_internet_gateway.main]
}

# Create route tables for public subnets This line 110-119 creates a route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id # associate the route table with the VPC
  tags = merge(
    var.public_route_table_tags, # this allows other users to specify their own tags for the public route table
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-public-route-table" # Name of the public route table roboshop-dev-public-route-table
    }
  )
}

# Create route tables for private subnets This line 122-131 creates a route table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id # associate the route table with the VPC
  tags = merge(
    var.private_route_table_tags, # this allows other users to specify their own tags for the private route table
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-private-route-table" # Name of the private route table roboshop-dev-private-route-table
    }
  )
}

# Create route tables for database subnets  This line 134-143 creates a route table for database subnets
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id # associate the route table with the VPC
  tags = merge(
    var.database_route_table_tags, # this allows other users to specify their own tags for the database route table
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-database-route-table" # Name of the database route table roboshop-dev-database-route-table
    }
  )
}

# Create routes for public subnets This line 146-150 creates a route for the public route table to allow internet access
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Create routes for private subnets This line 153-157 creates a route for the private route table to allow internet access via NAT Gateway
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.main.id
}


# create routes for database subnets This line 160-164 creates a route for the database route table to allow internet access via NAT Gateway
resource "aws_route" "database" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.main.id
}

# Associate public subnets with the public route table This line 168-172 associates each public subnet with the public route table
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs) 
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# associate private subnets with the private route table This line 175-179 associates each private subnet with the private route table
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs) 
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# associate database subnets with the database route table This line 182-186 associates each database subnet with the database route table
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}