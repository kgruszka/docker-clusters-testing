resource "null_resource" "bastion_kubectl" {
  connection {
    host = "${var.bastion_public_ip}"
    user = "${var.bastion_user}"
    private_key = "${file(var.bastion_private_key_path)}"
  }

  provisioner "file" {
    source = "${var.tls_data_dir}/ca.pem"
    destination = "/home/${var.bastion_user}/ca.pem"
  }

  provisioner "file" {
    source = "${var.tls_data_dir}/admin.pem"
    destination = "/home/${var.bastion_user}/admin.pem"
  }

  provisioner "file" {
    source = "${var.tls_data_dir}/admin-key.pem"
    destination = "/home/${var.bastion_user}/admin-key.pem"
  }

  provisioner "file" {
    content = "${data.template_file.kubernetes_bastion_kubectl.rendered}"
    destination = "/home/${var.bastion_user}/kubectl.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh /home/${var.bastion_user}/kubectl.sh"
    ]
  }
}