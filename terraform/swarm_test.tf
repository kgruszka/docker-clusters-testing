module "swarm_start_containers_test" {
  source = "modules/test"

  test_name = "swarm_start_stop_${var.slave_node_count}"

  bastion_public_ip = "${module.vpc.bastion_public_ip}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"
  manager_machine_ips = "${module.swarm.swarm_manager_private_ips}"
  worker_machine_ips = "${module.swarm.swarm_worker_private_ips}"
  worker_machine_count = "${var.slave_node_count}"

  agent_dir_path = "../tests/agent"
  test_dir_path = "../tests/start_containers/swarm"

  db_host_public_ip = "${module.db_service.public_ip}"
  db_host_private_ip = "${module.db_service.private_ip}"
  db_port = "${module.db_service.port}"
  db_auth = "${module.db_service.auth}"

  depends_on = "${concat(
    module.swarm.swarm_managers_provisioned,
    module.swarm.swarm_workers_provisioned
  )}"
}

module "swarm_update_containers_test" {
  source = "modules/test"

  test_name = "swarm_update_${var.slave_node_count}"

  bastion_public_ip = "${module.vpc.bastion_public_ip}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"
  manager_machine_ips = "${module.swarm.swarm_manager_private_ips}"
  worker_machine_ips = "${module.swarm.swarm_worker_private_ips}"
  worker_machine_count = "${var.slave_node_count}"

  agent_dir_path = "../tests/agent"
  test_dir_path = "../tests/update/swarm"

  db_host_public_ip = "${module.db_service.public_ip}"
  db_host_private_ip = "${module.db_service.private_ip}"
  db_port = "${module.db_service.port}"
  db_auth = "${module.db_service.auth}"

  depends_on = "${concat(
    module.swarm.swarm_managers_provisioned,
    module.swarm.swarm_workers_provisioned
  )}"
}

module "swarm_failure_test" {
  source = "modules/test"

  test_name = "swarm_failure_${var.slave_node_count}"

  bastion_public_ip = "${module.vpc.bastion_public_ip}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"
  manager_machine_ips = "${module.swarm.swarm_manager_private_ips}"
  worker_machine_ips = "${module.swarm.swarm_worker_private_ips}"
  worker_machine_count = "${var.slave_node_count}"

  agent_dir_path = "../tests/agent"
  test_dir_path = "../tests/failure/swarm"

  db_host_public_ip = "${module.db_service.public_ip}"
  db_host_private_ip = "${module.db_service.private_ip}"
  db_port = "${module.db_service.port}"
  db_auth = "${module.db_service.auth}"

  depends_on = "${concat(
    module.swarm.swarm_managers_provisioned,
    module.swarm.swarm_workers_provisioned
  )}"
}