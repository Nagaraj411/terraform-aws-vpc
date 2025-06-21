data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" { # This data source retrieves the default VPC in the region
  default = true
}

# output "azs_info" { # This output will provide the availability zones used in the VPC module
#     value = data.aws_availability_zones.available
# }

data "aws_route_table" "main" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}