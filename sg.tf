resource "aws_security_group" "cluster" {
  name        = "cluster"
  description = "Security group for swarm cluster instances"
  vpc_id      = "${aws_vpc.clusters.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port   = 0
    to_port     = 2375
    protocol    = "tcp"
    cidr_blocks = [
      "${aws_vpc.clusters.cidr_block}"
    ]
  }

  ingress {
    from_port   = 2375
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = [
      "${aws_vpc.clusters.cidr_block}"
    ]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = [
      "${aws_vpc.clusters.cidr_block}"
    ]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = [
      "${aws_vpc.clusters.cidr_block}"
    ]
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "tcp"
    cidr_blocks = [
      "${aws_vpc.clusters.cidr_block}"
    ]
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = [
      "${aws_vpc.clusters.cidr_block}"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}