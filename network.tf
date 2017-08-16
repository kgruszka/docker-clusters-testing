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

resource "aws_route_table" "swarm" {
  vpc_id = "${aws_vpc.clusters.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.clusters.id}"
  }
}

resource "aws_route_table" "kubernetes" {
  vpc_id = "${aws_vpc.clusters.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.clusters.id}"
  }
}

resource "aws_route_table_association" "swarm" {
  route_table_id = "${aws_route_table.swarm.id}"
  subnet_id = "${aws_subnet.swarm.id}"
}

resource "aws_route_table_association" "kubernetes" {
  route_table_id = "${aws_route_table.kubernetes.id}"
  subnet_id = "${aws_subnet.kubernetes.id}"
}