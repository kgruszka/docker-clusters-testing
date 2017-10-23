resource "aws_instance" "kubernetes_worker" {
  count = "${var.worker_count}"
  ami = "${var.worker_ami}"
  instance_type = "${var.worker_instance_type}"
  key_name = "${var.cluster_key_name}"
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  private_ip = "${cidrhost(var.subnet_cidr, 20 + count.index)}"

  vpc_security_group_ids = ["${aws_security_group.kubernetes_worker.id}"]

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform",
    Role = "Kubernetes worker"
  }
}

resource "null_resource" "kubernetes_worker" {
  depends_on = [
    "null_resource.control_plane",
    "null_resource.kubernetes_worker_tls",
    "aws_elb.kubernetes_worker",
    "aws_route.kubernetes_pods_routing"
  ]
  count = "${aws_instance.kubernetes_worker.count}"

  connection {
    bastion_host = "${var.bastion_ip}"
    host = "${element(aws_instance.kubernetes_worker.*.private_ip, count.index)}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.cluster_user}/scripts"
    ]
  }

  provisioner "file" {
    source      = "${var.local_scripts_path}/private_ip_to_hosts_file.sh"
    destination = "/home/${var.cluster_user}/scripts/private_ip_to_hosts_file.sh"
  }

  provisioner "file" {
    content = "${element(data.template_file.k8s_worker_init.*.rendered, count.index)}"
    destination = "/home/${var.cluster_user}/scripts/worker_init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x scripts/private_ip_to_hosts_file.sh",
      "sudo sh scripts/private_ip_to_hosts_file.sh '${element(aws_instance.kubernetes_worker.*.private_ip, count.index)}'"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh scripts/worker_init.sh"
    ]
  }
}

output "worker_private_ips" {
  value = "${aws_instance.kubernetes_worker.*.private_ip}"
}

output "kubernetes_workers_provisioned" {
  value = "${null_resource.kubernetes_worker.*.id}"
}