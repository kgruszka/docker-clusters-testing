variable "region" {}

variable "manager_ami" {}
variable "worker_ami" {}
variable "manager_instance_type" {}
variable "worker_instance_type" {}
variable "worker_count" {}
variable "manager_count" {}

variable "bastion_ip" {}
variable "cluster_key_name" {}
variable "cluster_user" {}
variable "cluster_private_key_path" {}

variable "vpc_id" {}
variable "vpc_cidr" {}
variable "subnet_id" {}
variable "subnet_cidr" {}
variable "pod_cidr" {
  default = "10.200.0.0/16"
}
variable "kubernetes_route_table_id" {}

variable "app_tag" {}

variable local_scripts_path {}
