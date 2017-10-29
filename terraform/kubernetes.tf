module "kubernetes" {
  source = "modules/kubernetes"

  region = "${var.region}"

  bastion_ip = "${module.vpc.bastion_public_ip}"
  cluster_key_name = "${module.vpc.cluster-key-name}"
  cluster_user = "${var.cluster_user}"
  cluster_private_key_path = "${var.cluster_private_key_path}"

  # manager
  manager_ami = "${var.manager_ami}"
  manager_instance_type = "${var.master_node_instance_type}"
  manager_count = "${var.master_node_count}"

  # worker
  worker_ami = "${var.worker_ami}"
  worker_instance_type = "${var.slave_node_instance_type}"
  worker_count = "${var.slave_node_count}"

  # networking
  vpc_id = "${module.vpc.vpc_cluster_id}"
  vpc_cidr = "${module.vpc.vpc_cluster_cidr}"
  subnet_id = "${module.vpc.cluster_subnet_id}"
  subnet_cidr = "${module.vpc.cluster_subnet_cidr}"
  kubernetes_route_table_id = "${module.vpc.cluster_route_table_id}"

  app_tag = "${var.app_tag}"
  local_scripts_path = "${var.local_scripts_path}"
}

//module "kubectl" {
//  source = "modules/local_kubectl"
//  kubernetes_public_address = "${module.kubernetes.kubernetes_manager_public_ips[0]}"
//  tls_data_dir = "modules/kubernetes/tls/data"
//}
//
//module "bastion_kubectl" {
//  source = "modules/bastion_kubectl"
//
//  kubernetes_public_address = "${module.kubernetes.kubernetes_manager_public_ips[0]}"
//  bastion_public_ip = "${module.vpc.bastion_public_ip}"
//  bastion_user = "${var.cluster_user}"
//  bastion_private_key_path = "${var.cluster_private_key_path}"
//  tls_data_dir = "modules/kubernetes/tls/data/generated"
//}

output "kubernetes_manager_private_ips" {
  value = "${module.kubernetes.kubernetes_manager_private_ips}"
}

output "kubernetes_manager_public_ips" {
  value = "${module.kubernetes.kubernetes_manager_public_ips}"
}

output "kubernetes_worker_private_ips" {
  value = "${module.kubernetes.worker_private_ips}"
}

output "kubernetes_manager_elb_dns_name" {
  value = "${module.kubernetes.kubernetes_manager_elb_dns_name}"
}

output "kubernetes_worker_elb_dns_name" {
  value = "${module.kubernetes.kubernetes_worker_elb_dns_name}"
}