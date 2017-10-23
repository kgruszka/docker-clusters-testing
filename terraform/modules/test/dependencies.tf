resource "null_resource" "module_depenencies" {
  provisioner "local-exec" {
    command = "echo \"${join(",", var.depends_on)}\""
  }
}