resource "aws_vpc" "clusters" {
  cidr_block = "${var.vpc_cidr_block_base}/${var.vpc_cidr_block_mask}"
}
