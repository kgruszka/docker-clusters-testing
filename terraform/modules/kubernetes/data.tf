data "template_file" "etcd_init" {
  template = "${file("${path.module}/data/etcd_init.sh")}"
  count = "${var.manager_count}"

  vars {
    IP = "${element(aws_instance.kubernetes_manager.*.private_ip, count.index)}"
    HOSTNAME = "${element(aws_instance.kubernetes_manager.*.id, count.index)}"
    CLUSTER = "${join(",", formatlist("%s=https://%s:2380", aws_instance.kubernetes_manager.*.id, aws_instance.kubernetes_manager.*.private_ip))}"
    TOKEN = "${random_string.etcd_token.result}"
  }
}

data "template_file" "k8s_manager_init" {
  template = "${file("${path.module}/data/k8s_manager_init.sh")}"
  count = "${var.manager_count}"

  vars {
    IP = "${element(aws_instance.kubernetes_manager.*.private_ip, count.index)}"
    HOSTNAME = "${element(aws_instance.kubernetes_manager.*.id, count.index)}"
    ETCD_URLS = "${join(",", formatlist("https://%s:2379", aws_instance.kubernetes_manager.*.private_ip))}"
    MANAGER_COUNT = "${var.manager_count}"
  }
}

data "template_file" "k8s_worker_init" {
  count = "${var.worker_count}"
  template = "${file("${path.module}/data/k8s_worker_init.sh")}"

  vars {
    POD_CIDR = "${cidrsubnet(var.pod_cidr, 8, count.index)}"
    WORKER_NAME = "worker-${count.index}"
  }
}

resource "random_string" "etcd_token" {
  length = 16
  special = true
}