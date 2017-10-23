// nodes
variable "region" {}
variable "manager_ami" {}
variable "worker_ami" {}

variable "master_node_count" {}
variable "slave_node_count" {}
variable "master_node_instance_type" {}
variable "slave_node_instance_type" {}

variable "cluster_user" {}
variable "cluster_key_name" {}
variable "cluster_private_key_path" {}

// network
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "subnet_id" {}

// bastion
variable "bastion_public_ip" {}

// test
variable containers_count {}
variable local_scripts_path {}