resource "aws_instance" "kubernetes_manager" {
  count = "${var.manager_count}"
  ami = "${var.manager_ami}"
  instance_type = "${var.manager_instance_type}"
  key_name = "${var.cluster_key_name}"
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  private_ip = "${cidrhost(var.subnet_cidr, 10 + count.index)}"

  vpc_security_group_ids = ["${aws_security_group.kubernetes_manager.id}"]

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform",
    Role = "Kubernetes manager"
  }
}

resource "null_resource" "kubernetes_manager" {
  count = "${var.manager_count}"

  connection {
    bastion_host = "${var.bastion_ip}"
    host = "${element(aws_instance.kubernetes_manager.*.private_ip, count.index)}"
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

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x scripts/private_ip_to_hosts_file.sh",
      "sudo sh scripts/private_ip_to_hosts_file.sh '${element(aws_instance.kubernetes_manager.*.private_ip, count.index)}'"
    ]
  }
}

resource "null_resource" "control_plane" {
  depends_on = [
    "null_resource.kubernetes_manager",
    "null_resource.kubernetes_manager_tls",
    "aws_elb.kubernetes_manager",
    "null_resource.etcd",
  ]
  count = "${var.manager_count}"

  connection {
    bastion_host = "${var.bastion_ip}"
    host = "${element(aws_instance.kubernetes_manager.*.private_ip, count.index)}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "file" {
    content = "${element(data.template_file.k8s_manager_init.*.rendered, count.index)}"
    destination = "/home/${var.cluster_user}/scripts/control_plane_init.sh"
  }

  provisioner "file" {
    content = "${file("${path.module}/data/cluster_role.yml")}"
    destination = "/home/${var.cluster_user}/cluster_role.yml"
  }

  provisioner "file" {
    content = "${file("${path.module}/data/cluster_role_binding.yml")}"
    destination = "/home/${var.cluster_user}/cluster_role_binding.yml"
  }

  provisioner "remote-exec" {
    inline = ["sudo sh scripts/control_plane_init.sh"]
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "kubectl apply -f cluster_role.yml",
      "kubectl apply -f cluster_role_binding.yml"
    ]
  }
}

output "kubernetes_manager_public_ips" {
  value = "${aws_instance.kubernetes_manager.*.public_ip}"
}

output "kubernetes_manager_private_ips" {
  value = "${aws_instance.kubernetes_manager.*.private_ip}"
}

output "kubernetes_managers_provisioned" {
  value = "${null_resource.control_plane.*.id}"
}