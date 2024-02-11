variable "vpc_id" {}
variable "service_name" {}
variable "vpc_endpoint_type" {}
variable "route_table_ids" {}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = var.vpc_id
  service_name      = var.service_name
  vpc_endpoint_type = var.vpc_endpoint_type
  route_table_ids   = var.route_table_ids
}