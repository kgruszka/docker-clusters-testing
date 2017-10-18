resource "aws_security_group" "swarm_manager" {
  name        = "swarm manager"
  vpc_id      = "${var.vpc_id}"
  description = "swarm manager security group"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
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
  vpc_id      = "${var.vpc_id}"
  description = "swarm worker security group"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
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
output "swarm_manager_security_group_id" {
  value = "${aws_security_group.swarm_manager.id}"
}

output "swarm_worker_security_group_id" {
  value = "${aws_security_group.swarm_worker.id}"
}