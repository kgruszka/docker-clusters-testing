resource "null_resource" "init_manager" {
  depends_on = ["null_resource.module_depenencies"]

  connection {
    bastion_host = "${var.bastion_public_ip}"
    host = "${var.manager_machine_ips[0]}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf init",
      "mkdir -p /home/${var.cluster_user}/init"
    ]
  }

  provisioner "file" {
    source = "${var.test_dir_path}/init_manager/"
    destination = "/home/${var.cluster_user}/init/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh init/init.sh"
    ]
  }
}

resource "null_resource" "init_worker" {
  depends_on = ["null_resource.module_depenencies"]

  count = "${var.worker_machine_count}"

  connection {
    bastion_host = "${var.bastion_public_ip}"
    host = "${element(var.worker_machine_ips, count.index)}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf init",
      "mkdir -p /home/${var.cluster_user}/init"
    ]
  }

  provisioner "file" {
    source = "${var.test_dir_path}/init_worker/"
    destination = "/home/${var.cluster_user}/init/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh init/init.sh"
    ]
  }
}