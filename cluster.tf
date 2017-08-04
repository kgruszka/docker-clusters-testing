module "swarm" {
  source = "./swarm"

  region = "${var.region}"

  cluster_user = "${var.cluster_user}"
  key_name = "${aws_key_pair.ec2-key.key_name}"
  cluster_private_key_path = "${var.cluster_private_key_path}"
  master_node_count = "${var.master_node_count}"
  slave_node_count = "${var.slave_node_count}"
  amis = "${var.amis}"
  master_node_instance_type = "${var.master_node_instance_type}"
  slave_node_instance_type = "${var.slave_node_instance_type}"

  vpc_id = "${aws_vpc.clusters.id}"
  sg_id = "${aws_security_group.cluster.id}"
  subnet_id = "${aws_subnet.swarm.id}"
}

output "master_ip" {
  value = "${module.swarm.master_ip}"
}

output "master_private_ip" {
  value = "${module.swarm.master_private_ip}"
}

output "slave_ips" {
  value = "${module.swarm.slaves}"
}