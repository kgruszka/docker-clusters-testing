variable "worker_machine_ips" {
  type = "list"
}

variable "manager_machine_ips" {
  type = "list"
}

variable "worker_machine_count" {}

variable "bastion_public_ip" {}
variable "cluster_user" {}
variable "cluster_private_key_path" {}

variable "test_dir_path" {}
variable "agent_dir_path" {}

variable "depends_on" {
  type = "list"
}

variable "db_host_public_ip" {}
variable "db_host_private_ip" {}
variable "db_port" {}
variable "db_auth" {}
variable "test_name" {}