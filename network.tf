resource "aws_subnet" "swarm" {
  cidr_block = "${var.swarm_subnet_cidr_block_base}/${var.swarm_subnet_cidr_block_mask}"
  vpc_id = "${aws_vpc.clusters.id}"
  availability_zone = "${var.availability_zone}"
}

resource "aws_subnet" "kubernetes" {
  cidr_block = "${var.kubernetes_subnet_cidr_block_base}/${var.kubernetes_subnet_cidr_block_mask}"
  vpc_id = "${aws_vpc.clusters.id}"
  availability_zone = "${var.availability_zone}"
}

resource "aws_internet_gateway" "clusters" {
  vpc_id = "${aws_vpc.clusters.id}"
}

resource "aws_route_table" "clusters" {
  vpc_id = "${aws_vpc.clusters.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.clusters.id}"
  }
}

resource "aws_route_table_association" "swarm" {
  route_table_id = "${aws_route_table.clusters.id}"
  subnet_id = "${aws_subnet.swarm.id}"
}

resource "aws_route_table_association" "kubernetes" {
  route_table_id = "${aws_route_table.clusters.id}"
  subnet_id = "${aws_subnet.kubernetes.id}"
}

resource "aws_network_acl" "network" {
  vpc_id = "${aws_vpc.clusters.id}"
  subnet_ids = [
    "${aws_subnet.swarm.id}",
    "${aws_subnet.kubernetes.id}"
  ]

  ingress {
    from_port = 0
    to_port = 0
    rule_no = 100
    action = "allow"
    protocol = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    from_port = 0
    to_port = 0
    rule_no = 100
    action = "allow"
    protocol = "-1"
    cidr_block = "0.0.0.0/0"
  }
}