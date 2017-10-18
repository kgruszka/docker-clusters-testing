resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "sh ${path.module}/data/kubectl.sh ${var.kubernetes_public_address} ${var.tls_data_dir}"
  }
}
