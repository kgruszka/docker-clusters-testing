resource "null_resource" "tls" {
  provisioner "local-exec" {
    command = "sh ${path.module}/data/generate.sh ${var.worker_public_ips} ${var.worker_private_ips} ${var.manager_public_ips} ${var.manager_private_ips} ${var.manager_public_address}"
  }
}

data "template_file" "kubernetes_worker_ca_pem" {
  depends_on = ["null_resource.tls"]
  template = "${path.module}/data/generated/ca.pem"
}

data "template_file" "kubernetes_worker_instance_key_pem" {
  depends_on = ["null_resource.tls"]
  count = "${var.worker_count}"

  template = "${path.module}/data/generated/worker-${count.index}-key.pem"
}

data "template_file" "kubernetes_worker_instance_pem" {
  depends_on = ["null_resource.tls"]
  count = "${var.worker_count}"

  template = "${path.module}/data/generated/worker-${count.index}.pem"
}

data "template_file" "kubernetes_worker_kubeconfig" {
  depends_on = ["null_resource.tls"]
  count = "${var.worker_count}"

  template = "${path.module}/data/generated/worker-${count.index}.kubeconfig"
}

data "template_file" "kubernetes_kube_proxy_kubeconfig" {
  depends_on = ["null_resource.tls"]

  template = "${path.module}/data/generated/kube-proxy.kubeconfig"
}

data "template_file" "kubernetes_manager_ca_pem" {
  depends_on = ["null_resource.tls"]

  template = "${path.module}/data/generated/ca.pem"
}

data "template_file" "kubernetes_manager_ca_key_pem" {
  depends_on = ["null_resource.tls"]

  template = "${path.module}/data/generated/ca-key.pem"
}

data "template_file" "kubernetes_manager_kubernetes_key_pem" {
  depends_on = ["null_resource.tls"]

  template = "${path.module}/data/generated/kubernetes-key.pem"
}

data "template_file" "kubernetes_manager_kubernetes_pem" {
  depends_on = ["null_resource.tls"]

  template = "${path.module}/data/generated/kubernetes.pem"
}

output "kubernetes_worker_ca_pem" {
  value = "${data.template_file.kubernetes_worker_ca_pem.rendered}"
}

output "kubernetes_worker_instance_key_pem" {
  value = "${data.template_file.kubernetes_worker_instance_key_pem.*.rendered}"
}

output "kubernetes_worker_instance_pem" {
  value = "${data.template_file.kubernetes_worker_instance_pem.*.rendered}"
}

output "kubernetes_worker_kubeconfig" {
  value = "${data.template_file.kubernetes_worker_kubeconfig.*.rendered}"
}

output "kubernetes_kube_proxy_kubeconfig" {
  value = "${data.template_file.kubernetes_kube_proxy_kubeconfig.rendered}"
}

output "kubernetes_manager_ca_pem" {
  value = "${data.template_file.kubernetes_manager_ca_pem.rendered}"
}

output "kubernetes_manager_ca_key_pem" {
  value = "${data.template_file.kubernetes_manager_ca_key_pem.rendered}"
}

output "kubernetes_manager_kubernetes_key_pem" {
  value = "${data.template_file.kubernetes_manager_kubernetes_key_pem.rendered}"
}

output "kubernetes_manager_kubernetes_pem" {
  value = "${data.template_file.kubernetes_manager_kubernetes_pem.rendered}"
}

output "certificate_generation" {
  depends_on = ["null_resource.tls"]
  value = "${null_resource.tls.id}"
}