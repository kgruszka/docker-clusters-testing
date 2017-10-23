module "swarm_start_containers_test" {
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