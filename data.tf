data "aws_availability_zones" "available" {
  state = "available"
}

output "azs_info" { # This output will provide the availability zones used in the VPC module
    value = data.aws_availability_zones.available
}