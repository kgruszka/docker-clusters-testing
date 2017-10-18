module "tls" {
  source = "tls/"

  worker_public_ips = "${join(",", aws_instance.kubernetes_worker.*.public_ip)}"
  worker_private_ips = "${join(",", aws_instance.kubernetes_worker.*.private_ip)}"
  manager_public_ips = "${join(",", aws_instance.kubernetes_manager.*.public_ip)}"
  manager_private_ips = "${join(",", aws_instance.kubernetes_manager.*.private_ip)}"
  manager_public_address = "${aws_elb.kubernetes_manager.dns_name}"

  worker_count = "${var.worker_count}"
}

resource "null_resource" "kubernetes_worker_tls" {
  count = "${aws_instance.kubernetes_worker.count}"

  connection {
    bastion_host = "${var.bastion_ip}"
    host = "${element(aws_instance.kubernetes_worker.*.private_ip, count.index)}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "file" {
    content = "${module.tls.kubernetes_worker_ca_pem}"
    destination = "/home/${var.cluster_user}/ca.pem"
  }

  provisioner "file" {
    content = "${element(module.tls.kubernetes_worker_instance_key_pem, count.index)}"
    destination = "/home/${var.cluster_user}/worker-${count.index}-key.pem"
  }

  provisioner "file" {
    content = "${element(module.tls.kubernetes_worker_instance_pem, count.index)}"
    destination = "/home/${var.cluster_user}/worker-${count.index}.pem"
  }

  provisioner "file" {
    content = "${element(module.tls.kubernetes_worker_kubeconfig, count.index)}"
    destination = "/home/${var.cluster_user}/worker-${count.index}.kubeconfig"
  }

  provisioner "file" {
    content = "${module.tls.kubernetes_kube_proxy_kubeconfig}"
    destination = "/home/${var.cluster_user}/kube-proxy.kubeconfig"
  }
}

resource "null_resource" "kubernetes_manager_tls" {
  count = "${aws_instance.kubernetes_manager.count}"

  connection {
    bastion_host = "${var.bastion_ip}"
    host = "${element(aws_instance.kubernetes_manager.*.private_ip, count.index)}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "file" {
    content = "${module.tls.kubernetes_manager_ca_pem}"
    destination = "/home/${var.cluster_user}/ca.pem"
  }

  provisioner "file" {
    content = "${module.tls.kubernetes_manager_ca_key_pem}"
    destination = "/home/${var.cluster_user}/ca-key.pem"
  }

  provisioner "file" {
    content = "${module.tls.kubernetes_manager_kubernetes_key_pem}"
    destination = "/home/${var.cluster_user}/kubernetes-key.pem"
  }

  provisioner "file" {
    content = "${module.tls.kubernetes_manager_kubernetes_pem}"
    destination = "/home/${var.cluster_user}/kubernetes.pem"
  }
}
