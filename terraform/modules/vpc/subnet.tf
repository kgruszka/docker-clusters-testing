resource "aws_subnet" "cluster" {
  cidr_block = "10.0.0.0/24"
  vpc_id = "${aws_vpc.cluster.id}"
  availability_zone = "${var.availability_zone}"

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform",
    Role = "Kubernetes"
  }
}

resource "aws_internet_gateway" "cluster" {
  vpc_id = "${aws_vpc.cluster.id}"

  tags = {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform"
    Role = "Kubernetes"
  }
}

resource "aws_route_table" "cluster" {
  vpc_id = "${aws_vpc.cluster.id}"

  tags = {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform"
    Role = "Kubernetes"
  }
}

resource "aws_route" "cluster_egress_route" {
  route_table_id = "${aws_route_table.cluster.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.cluster.id}"
}

resource "aws_route_table_association" "cluster" {
  route_table_id = "${aws_route_table.cluster.id}"
  subnet_id = "${aws_subnet.cluster.id}"
}

output "cluster_subnet_id" {
  depends_on = ["aws_route_table_association.cluster"]
  value = "${aws_subnet.cluster.id}"
}

output "cluster_subnet_cidr" {
  depends_on = ["aws_route_table_association.cluster"]
  value = "${aws_subnet.cluster.cidr_block}"
}

output "cluster_route_table_id" {
  depends_on = ["aws_route_table_association.cluster"]
  value = "${aws_route_table.cluster.id}"
}