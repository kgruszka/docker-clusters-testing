module "db_service" {
    source = "modules/db_service"

    region = "${var.region}"
    docker_ami = "${var.bastion_ami}"
    ec2-private-key = "${var.cluster_private_key_path}"
    ec2-key-name = "${module.vpc.cluster-key-name}"

    vpc_id = "${module.vpc.vpc_cluster_id}"
    vpc_cidr = "${module.vpc.vpc_cluster_cidr}"
    subnet_id = "${module.vpc.cluster_subnet_id}"
}

output "db_service_public_ip" {
    value = "${module.db_service.public_ip}"
}