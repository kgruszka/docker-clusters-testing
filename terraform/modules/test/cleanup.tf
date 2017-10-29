resource "null_resource" "cleanup_worker" {
  depends_on = [
    "null_resource.test",
    "null_resource.test_results",
  ]

  count = "${var.worker_machine_count}"

  connection {
    bastion_host = "${var.bastion_public_ip}"
    host = "${element(var.worker_machine_ips, count.index)}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf cleanup",
      "mkdir -p /home/${var.cluster_user}/cleanup"
    ]
  }

  provisioner "file" {
    source = "${var.test_dir_path}/cleanup/worker"
    destination = "/home/${var.cluster_user}/cleanup/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh cleanup/cleanup.sh",
      "sudo sh agent/cleanup.sh",
      "curl -X PUT -H \"Content-Type: application/json\" -H \"Authorization: Basic ${var.db_auth}\" ${var.db_host_private_ip}:${var.db_port}/test/${var.test_name}"
    ]
  }
}