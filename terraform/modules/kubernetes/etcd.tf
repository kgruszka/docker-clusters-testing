resource "null_resource" "etcd" {
  depends_on = ["null_resource.kubernetes_manager_tls"]
  count = "${var.manager_count}"

  connection {
    bastion_host = "${var.bastion_ip}"
    host = "${element(aws_instance.kubernetes_manager.*.private_ip, count.index)}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "file" {
    content = "${element(data.template_file.etcd_init.*.rendered, count.index)}"
    destination = "/home/${var.cluster_user}/etcd_init.sh"
  }

  provisioner "remote-exec" {
    inline = ["sudo sh etcd_init.sh"]
  }
}