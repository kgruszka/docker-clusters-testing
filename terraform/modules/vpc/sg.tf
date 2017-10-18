resource "aws_security_group" "bastion" {
  name = "bastion"
  vpc_id = "${aws_vpc.cluster.id}"
  description = "cluster bastion security group"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform",
    Role = "Cluster bastion"
  }
}