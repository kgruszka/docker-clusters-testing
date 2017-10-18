// provider
variable "bastion_ami" {}
variable "availability_zone" {}

// cluster nodes
variable "amis" {
  type = "map"
  default = {
    "eu-central-1" = "ami-0804ac67"
  }
}

variable "cluster_user" {
  default = "ubuntu"
}

variable "ec2-key" {
  type = "map"
  default = {
    "prefix" = "docker-cluster-instance"
    "public_key"= "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6Nb3KkpRNeyg2pSJpyuOVQQhhXhvCx7gDDOrQRws0VWWF4SsbbW/8j+QiYJz+ufmCeFEvT6Uxmy6NUuu51nCQ45VbJUJoAgKzwx9imc6QuOTD0EUqn8D75zUE1tDJvPDon9keSsDjlz19c5FVx/si5CxTStZB0RXw3lJ07ta4rThM8DV1zrXHDCDzZomnFMneFrEefX/mDImJITYXEWjrQ1rsOlhxJcOq4NelAiEtqlaGp+OtS+8nQagXQpoFtPRVFK41Y6WobFpSPWLFTLKWOuexXr/cN7wIZvoP2tUS254O+31Nw3OSJTWM2VdE/MRzB82AXEplWJoLQBu34QvMMXRRWy9aUFF6jvhr9Hu67qOZEM22aSOpoQ9e8SB2YaWCO51tsJsU7xglg5RKHI7dIPeoELqOKIpEkU2mA/5c39nLivNufiSr/y9dePUS9Hz9ot89zrb2+ciCwMIPsH7MKpZQovuc/sbFDdl5dzEu9cOIeXgGT9lpfgrPI6wQiDXc3N35N4MuMPpFbxHwIGnz+rsBD7Go9eSVmA0wWcYGrHwQipFFX+4pS11RWkRKTgaIt/RjlvYBOsDvP6OGztexGmA3E25Czk62eAPGLWz7v3gwZQa+RrliK3UoMbA4C6vjOSd/yT3mNfIxo+bGoCi+3Q7+XemaWbfzl0ePPc93qQ=="
  }
}

variable "cluster_private_key_path" {}

// tests
variable "master_node_instance_type" {
  default = "t2.micro"
}
variable "slave_node_instance_type" {
  default = "t2.micro"
}
variable "master_node_count" {}
variable "slave_node_count" {}
variable "containers_count" {}

variable local_scripts_path {}
variable local_test_dir_path {}

// bastion
variable "bastion_instance_type" {
  default = "t2.micro"
}

// networking
variable "vpc_cidr_block_base" {
  default = "10.0.0.0"
}
variable "vpc_cidr_block_mask" {
  default = "16"
}

variable "swarm_subnet_cidr_block_base" {
  default = "10.0.0.0"
}
variable "swarm_subnet_cidr_block_mask" {
  default = "24"
}

variable kubernetes_subnet_cidr_block_base {
  default = "10.0.1.0"
}
variable kubernetes_subnet_cidr_block_mask {
  default = "24"
}

// storage
variable storage_port {
  default = "8080"
}
variable storage_auth {
  default = "YWRtaW46Y2hhbmdlaXQ="
}
variable storage_path {
  default = "/tests/start-containers"
}