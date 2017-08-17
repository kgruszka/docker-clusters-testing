// nodes
variable "region" {}
variable "amis" {
  type = "map"
}
variable "sg_id" {}
variable "key_name" {}
variable "cluster_private_key_path" {}
variable "master_node_count" {}
variable "slave_node_count" {}
variable "cluster_user" {}
variable "master_node_instance_type" {}
variable "slave_node_instance_type" {}

variable local_scripts_path {}
variable local_test_dir_path {}

// subnets
variable "vpc_id" {}
variable "subnet_id" {}

// bastion
variable "bastion_public_ip" {}

// storage
variable storage_host {}
variable storage_port {}
variable storage_auth {}
variable storage_path {}