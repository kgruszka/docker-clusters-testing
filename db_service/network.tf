resource "aws_subnet" "db_service" {
  cidr_block = "10.0.0.0/24"
  vpc_id = "${aws_vpc.db_service.id}"
  availability_zone = "eu-central-1a"
}

resource "aws_internet_gateway" "db_service" {
  vpc_id = "${aws_vpc.db_service.id}"
}

resource "aws_route_table" "db_service" {
  vpc_id = "${aws_vpc.db_service.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.db_service.id}"
  }
}

resource "aws_route_table_association" "db_service" {
  route_table_id = "${aws_route_table.db_service.id}"
  subnet_id = "${aws_subnet.db_service.id}"
}