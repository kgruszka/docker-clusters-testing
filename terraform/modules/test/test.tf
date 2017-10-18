resource "null_resource" "test" {
  depends_on = [
    "null_resource.init_manager",
    "null_resource.init_worker"
  ]

  connection {
    bastion_host = "${var.bastion_public_ip}"
    host = "${var.manager_machine_ips[0]}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf test",
      "mkdir -p /home/${var.cluster_user}/test"
    ]
  }

  provisioner "file" {
    source = "${var.test_dir_path}/run/"
    destination = "/home/${var.cluster_user}/test/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh test/run.sh"
    ]
  }
}