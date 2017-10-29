module "kubernetes_start_containers_test" {
  source = "modules/test"

//  test_name = "kubernetes_start_containers_${var.slave_node_count}"
  test_name = "kubernetes_start_stop_${var.slave_node_count}"

  bastion_public_ip = "${module.vpc.bastion_public_ip}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"
  manager_machine_ips = "${module.kubernetes.kubernetes_manager_private_ips}"
  worker_machine_ips = "${module.kubernetes.worker_private_ips}"
  worker_machine_count = "${var.slave_node_count}"

  agent_dir_path = "../tests/agent"
  test_dir_path = "../tests/start_containers/kubernetes"

  db_host_public_ip = "${module.db_service.public_ip}"
  db_host_private_ip = "${module.db_service.private_ip}"
  db_port = "${module.db_service.port}"
  db_auth = "${module.db_service.auth}"

  depends_on = "${concat(
    module.kubernetes.kubernetes_managers_provisioned,
    module.kubernetes.kubernetes_workers_provisioned
  )}"
}

module "kubernetes_update_containers_test" {
  source = "modules/test"

  //  test_name = "kubernetes_start_containers_${var.slave_node_count}"
  test_name = "kubernetes_update_${var.slave_node_count}"

  bastion_public_ip = "${module.vpc.bastion_public_ip}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"
  manager_machine_ips = "${module.kubernetes.kubernetes_manager_private_ips}"
  worker_machine_ips = "${module.kubernetes.worker_private_ips}"
  worker_machine_count = "${var.slave_node_count}"

  agent_dir_path = "../tests/agent"
  test_dir_path = "../tests/update/kubernetes"

  db_host_public_ip = "${module.db_service.public_ip}"
  db_host_private_ip = "${module.db_service.private_ip}"
  db_port = "${module.db_service.port}"
  db_auth = "${module.db_service.auth}"

  depends_on = "${concat(
    module.kubernetes.kubernetes_managers_provisioned,
    module.kubernetes.kubernetes_workers_provisioned
  )}"
}

module "kubernetes_failure_test" {
  source = "modules/test"

  //  test_name = "kubernetes_start_containers_${var.slave_node_count}"
  test_name = "kubernetes_failure_${var.slave_node_count}"

  bastion_public_ip = "${module.vpc.bastion_public_ip}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"
  manager_machine_ips = "${module.kubernetes.kubernetes_manager_private_ips}"
  worker_machine_ips = "${module.kubernetes.worker_private_ips}"
  worker_machine_count = "${var.slave_node_count}"

  agent_dir_path = "../tests/agent"
  test_dir_path = "../tests/failure/kubernetes"

  db_host_public_ip = "${module.db_service.public_ip}"
  db_host_private_ip = "${module.db_service.private_ip}"
  db_port = "${module.db_service.port}"
  db_auth = "${module.db_service.auth}"

  depends_on = "${concat(
    module.kubernetes.kubernetes_managers_provisioned,
    module.kubernetes.kubernetes_workers_provisioned
  )}"
}