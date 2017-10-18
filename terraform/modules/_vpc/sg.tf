resource "aws_security_group" "swarm_manager" {
  name        = "swarm manager"
  vpc_id      = "${aws_vpc.clusters.id}"
  description = "swarm manager security group"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${aws_vpc.clusters.cidr_block}"]
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

resource "aws_security_group" "swarm_worker" {
  name        = "swarm worker"
  vpc_id      = "${aws_vpc.clusters.id}"
  description = "swarm worker security group"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${aws_vpc.clusters.cidr_block}"]
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

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Security group for the bastion instance"
  vpc_id      = "${aws_vpc.clusters.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
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

output "sg_cluster_id" {
  value = "${aws_security_group.cluster.id}"
}