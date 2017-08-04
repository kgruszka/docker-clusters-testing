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

// subnets
variable "vpc_id" {}
variable "subnet_id" {}
