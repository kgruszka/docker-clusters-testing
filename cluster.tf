module "swarm" {
  source = "./swarm"

  // provider
  region = "${var.region}"

  // cluster nodes
  amis = "${var.amis}"
  key_name = "${aws_key_pair.ec2-key.key_name}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"

  master_node_count = "${var.master_node_count}"
  slave_node_count = "${var.slave_node_count}"

  master_node_instance_type = "${var.master_node_instance_type}"
  slave_node_instance_type = "${var.slave_node_instance_type}"

  local_scripts_path = "${var.local_scripts_path}"
  local_test_dir_path = "${var.local_test_dir_path}"

  // networking
  vpc_id = "${aws_vpc.clusters.id}"
  sg_id = "${aws_security_group.cluster.id}"
  subnet_id = "${aws_subnet.swarm.id}"

  // bastion
  bastion_public_ip = "${aws_eip.bastion.public_ip}"

  // storage
  storage_host = "${var.storage_host}"
  storage_port = "${var.storage_port}"
  storage_auth = "${var.storage_auth}"
  storage_path = "${var.storage_path}"
}

output "master_private_ips" {
  value = "${module.swarm.master_private_ips}"
}

output "master_public_ips" {
  value = "${module.swarm.master_public_ips}"
}

output "slave_private_ips" {
  value = "${module.swarm.slave_private_ips}"
}

output "slave_public_ips" {
  value = "${module.swarm.slave_public_ips}"
}