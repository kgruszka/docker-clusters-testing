resource "aws_vpc" "clusters" {
  cidr_block = "${var.vpc_cidr_block_base}/${var.vpc_cidr_block_mask}"
}

output "vpc_clusters_id" {
  value = "${aws_vpc.clusters.id}"
}