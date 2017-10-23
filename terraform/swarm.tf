module "swarm" {
  source = "modules/swarm"

  // provider
  region = "${var.region}"


  // cluster nodes
  manager_ami = "${var.manager_ami}"
  worker_ami = "${var.worker_ami}"
  bastion_public_ip = "${module.vpc.bastion_public_ip}"
  cluster_key_name = "${module.vpc.cluster-key-name}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"

  master_node_count = "${var.master_node_count}"
  slave_node_count = "${var.slave_node_count}"

  master_node_instance_type = "${var.master_node_instance_type}"
  slave_node_instance_type = "${var.slave_node_instance_type}"

  // networking
  vpc_id = "${module.vpc.vpc_cluster_id}"
  vpc_cidr = "${module.vpc.vpc_cluster_cidr}"
  subnet_id = "${module.vpc.cluster_subnet_id}"

  local_scripts_path = "${var.local_scripts_path}"

  containers_count = "${var.containers_count}"
}

output "swarm_manager_public_ips" {
  value = "${module.swarm.swarm_manager_public_ips}"
}

output "swarm_manager_private_ips" {
  value = "${module.swarm.swarm_manager_private_ips}"
}

output "swarm_worker_public_ips" {
  value = "${module.swarm.swarm_worker_public_ips}"
}

output "swarm_worker_private_ips" {
  value = "${module.swarm.swarm_worker_private_ips}"
}