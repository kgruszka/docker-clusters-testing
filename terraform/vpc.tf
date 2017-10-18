//module "vpc" {
//    source = "modules\/_vpc"
//    bastion_ami = "${lookup(var.amis, var.region)}"
//    availability_zone = "${var.availability_zone}"
//    cluster_private_key_path = "${var.cluster_private_key_path}"
//
//    local_scripts_path = "${var.local_scripts_path}"
//    local_test_dir_path = "${var.local_test_dir_path}"
//
//    master_node_count = "${var.master_node_count}"
//    slave_node_count = "${var.slave_node_count}"
//    containers_count = "${var.containers_count}"
//}
module "vpc" {
    source = "modules/vpc"

    region = "${var.region}"
    availability_zone = "${var.availability_zone}"

    bastion_ami = "${var.bastion_ami}"
    bastion_instance_type = "${var.bastion_instance_type}"

    cluster_public_key = "${var.cluster_public_key}"
    bastion_user = "ubuntu"
    bastion_private_key_path = "${var.cluster_private_key_path}"

    local_scripts_path = "${var.local_scripts_path}"
    app_tag = "${var.app_tag}"
}

output "bastion_public_ip" {
    value = "${module.vpc.bastion_public_ip}"
}

output "bastion_private_ip" {
    value = "${module.vpc.bastion_private_ip}"
}