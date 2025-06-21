resource "aws_vpc_peering_connection" "default" {
  count = var.is_peering_required ? 1 : 0 # if peering is true 1 or else 0
  peer_vpc_id   = data.aws_vpc.default.id # this is the accepter default VPC
  vpc_id        = aws_vpc.main.id # this is the VPC requsted by the user

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
    auto_accept = true # automatically accept the peering connection

    # This is the tags for the peering connection
    tags = merge(
    var.vpc_peering_tags, # this allows other users to specify their own tags for the peering connection
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-default" # Name of the peering connection roboshop-dev-peering
    }
    )
}

# Create routes for public subnet
resource "aws_route" "public_peering" {
    count = var.is_peering_required ? 1 : 0
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = data.aws_vpc.default.cidr_block # this is the accepter default VPC CIDR block
  gateway_id             = aws_vpc_peering_connection.default[count.index].id # this is the peering connection ID
}

# Create routes for private subnet
resource "aws_route" "private_peering" {
    count = var.is_peering_required ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = data.aws_vpc.default.cidr_block # this is the accepter default VPC CIDR block
  gateway_id             = aws_vpc_peering_connection.default[count.index].id # this is the peering connection ID
}

# Create routes for database subnet
resource "aws_route" "database_peering" {
    count = var.is_peering_required ? 1 : 0
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = data.aws_vpc.default.cidr_block # this is the accepter default VPC CIDR block
  gateway_id             = aws_vpc_peering_connection.default[count.index].id # this is the peering connection ID
}

# we should also add the peering connection to the default VPC main route table
resource "aws_route" "default_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = data.aws_route_table.main.id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.default[count.index].id
}
