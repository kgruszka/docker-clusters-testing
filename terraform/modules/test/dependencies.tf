resource "null_resource" "module_depenencies" {
  provisioner "local-exec" {
    command = "$(echo \"${var.depends_on}\")"
  }
}