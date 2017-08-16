resource "aws_vpc" "db_service" {
  cidr_block = "10.0.0.0/16"
}
