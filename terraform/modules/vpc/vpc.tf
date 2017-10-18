resource "aws_vpc" "cluster" {
  cidr_block = "10.0.0.0/16"

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform",
    Role = "Kubernetes"
  }
}

output "vpc_cluster_id" {
  value = "${aws_vpc.cluster.id}"
}

output "vpc_cluster_cidr" {
  value = "${aws_vpc.cluster.cidr_block}"
}