// provider
variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-central-1"
}
variable "availability_zone" {}

// cluster nodes
variable "amis" {
  type = "map"
}

variable "ec2-key" {
  type = "map"
}

variable "cluster_private_key_path" {}
variable "cluster_user" {}
variable "master_node_count" {}
variable "slave_node_count" {}
variable "master_node_instance_type" {}
variable "slave_node_instance_type" {}

variable local_scripts_path {}
variable local_test_dir_path {
  default = "tests/start_containers"
}

// bastion
variable "bastion_instance_type" {}

// networking
variable "vpc_cidr_block_base" {}
variable "vpc_cidr_block_mask" {}

variable "swarm_subnet_cidr_block_base" {}
variable "swarm_subnet_cidr_block_mask" {}

variable kubernetes_subnet_cidr_block_mask {}
variable kubernetes_subnet_cidr_block_base {}

// mongo credentials
variable mongo_url {}