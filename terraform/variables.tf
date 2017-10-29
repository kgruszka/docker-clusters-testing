variable "region" {
  default = "us-east-1"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "cluster_user" {}
variable "cluster_public_key" {}
variable "cluster_private_key_path" {}

variable "manager_ami" {}
variable "worker_ami" {}

variable "master_node_instance_type" {}
variable "slave_node_instance_type" {}

variable "master_node_count" {
  default = 1
}
variable "slave_node_count" {
  default = 1
}

variable "app_tag" {}

// BASTION
variable "bastion_ami" {}
variable "bastion_instance_type" {}

// TESTS

variable "local_scripts_path" {}
variable "local_test_dir_path" {}
variable "test_script_dir" {}