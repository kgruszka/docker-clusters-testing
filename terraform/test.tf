module "kubernetes_test" {
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

module "swarm_test" {
  source = "modules/test"

  bastion_public_ip = "${module.vpc.bastion_public_ip}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"
  manager_machine_ips = "${module.swarm.swarm_manager_private_ips}"
  worker_machine_ips = "${module.swarm.swarm_worker_private_ips}"
  worker_machine_count = "${var.slave_node_count}"
  test_dir_path = "../test/swarm"

  depends_on = "${concat(
    module.swarm.swarm_managers_provisioned,
    module.swarm.swarm_workers_provisioned
  )}"

}