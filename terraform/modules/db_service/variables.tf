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
variable "db_port" {
  default = 8080
}
variable "db_auth" {
  default = "YWRtaW46Y2hhbmdlaXQ="
}
