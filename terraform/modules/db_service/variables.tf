variable "region" {}
variable "service_name" {
  default = "db_service"
}
variable "docker_ami" {}
variable "ec2-private-key" {}
variable "ec2-key-name" {}
variable "subnet_id" {}
variable "vpc_id" {}
variable "vpc_cidr" {}