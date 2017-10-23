module "kubernetes_start_containers_test" {
  source = "modules/test"

  bastion_public_ip = "${module.vpc.bastion_public_ip}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"
  manager_machine_ips = "${module.kubernetes.kubernetes_manager_private_ips}"
  worker_machine_ips = "${module.kubernetes.worker_private_ips}"
  worker_machine_count = "${var.slave_node_count}"
  test_dir_path = "../test/kubernetes"

  depends_on = "${concat(
    module.kubernetes.kubernetes_managers_provisioned,
    module.kubernetes.kubernetes_workers_provisioned
  )}"
}