resource "aws_security_group" "kubernetes_manager" {
  name = "kubernetes manager"
  vpc_id = "${var.vpc_id}"
  description = "kubernetes manager security group"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = ["${aws_security_group.kubernetes_manager_elb.id}"]
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
    Role = "Kubernetes manager"
  }
}

resource "aws_security_group" "kubernetes_worker" {
  name = "kubernetes worker"
  vpc_id = "${var.vpc_id}"
  description = "kubernetes worker security group"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
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
    Role = "Kubernetes worker"
  }
}

resource "aws_security_group" "kubernetes_etcd" {
  name = "kubernetes etcd"
  vpc_id = "${var.vpc_id}"
  description = "kubernetes etcd security group"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
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
    Role = "Kubernetes etcd"
  }
}

resource "aws_security_group" "kubernetes_manager_elb" {
  name = "kubernetes manager elb"
  vpc_id = "${var.vpc_id}"

  description = "kubernetes manager elb security group"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 6443
    to_port = 6443
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
    Role = "Kubernetes manager elb"
  }
}

resource "aws_security_group" "kubernetes_worker_elb" {
  name = "kubernetes worker elb"
  vpc_id = "${var.vpc_id}"
  description = "kubernetes worker elb security group"

  ingress {
    from_port = 80
    to_port = 80
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
    Role = "Kubernetes worker elb"
  }
}


output "kubernetes_manager_security_group_id" {
  value = "${aws_security_group.kubernetes_manager.id}"
}

output "kubernetes_worker_security_group_id" {
  value = "${aws_security_group.kubernetes_worker.id}"
}

output "kubernetes_etcd_security_group_id" {
  value = "${aws_security_group.kubernetes_etcd.id}"
}

output "kubernetes_manager_elb_security_group_id" {
  value = "${aws_security_group.kubernetes_manager_elb.id}"
}

output "kubernetes_worker_elb_security_group_id" {
  value = "${aws_security_group.kubernetes_worker_elb.id}"
}