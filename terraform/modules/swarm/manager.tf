resource "aws_instance" "swarm_manager" {
    instance_type = "${var.master_node_instance_type}"
    ami = "${var.manager_ami}"
    count = "${var.master_node_count}"
    subnet_id = "${var.subnet_id}"
    key_name = "${var.cluster_key_name}"
    associate_public_ip_address = "true"

    vpc_security_group_ids = [
        "${aws_security_group.swarm_manager.id}"
    ]
}

resource "null_resource" "provision-master-node" {
    # Changes to anys instance of the cluster requires re-provisioning
    triggers {
        cluster_instance_ids = "${aws_instance.swarm_manager.0.id}"
    }

    connection {
        bastion_host = "${var.bastion_public_ip}"
        user = "${var.cluster_user}"
        host = "${aws_instance.swarm_manager.0.private_ip}"
        private_key = "${file("${var.cluster_private_key_path}")}"
    }

    provisioner "remote-exec" {
        inline = [
            "mkdir -p /home/${var.cluster_user}/scripts"
        ]
    }

    provisioner "file" {
        source      = "${var.local_scripts_path}/private_ip_to_hosts_file.sh"
        destination = "/home/${var.cluster_user}/scripts/private_ip_to_hosts_file.sh"
    }

    provisioner "file" {
        content     = "${data.template_file.init_master.rendered}"
        destination = "/home/${var.cluster_user}/scripts/init_node.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo chmod +x scripts/*",
            "sudo sh scripts/private_ip_to_hosts_file.sh ${aws_instance.swarm_manager.0.private_ip}",
            "sudo sh scripts/init_node.sh"
        ]
    }
}

resource "null_resource" "provision-manager-node" {
    depends_on = [
        "null_resource.provision-master-node"
    ]

    triggers {
        cluster_instance_ids = "${join(",", aws_instance.swarm_manager.*.id)}"
    }
    count = "${var.master_node_count - 1}"

    connection {
        bastion_host = "${var.bastion_public_ip}"
        user = "${var.cluster_user}"
        host = "${element(aws_instance.swarm_manager.*.private_ip, count.index + 1)}"
        private_key = "${file(var.cluster_private_key_path)}"
    }

    provisioner "remote-exec" {
        inline = [
            "mkdir -p /home/${var.cluster_user}/scripts"
        ]
    }

    provisioner "file" {
        source      = "${var.local_scripts_path}/private_ip_to_hosts_file.sh"
        destination = "/home/${var.cluster_user}/scripts/private_ip_to_hosts_file.sh"
    }

    provisioner "file" {
        content     = "${data.template_file.init_manager.rendered}"
        destination = "/home/${var.cluster_user}/scripts/init_node.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo chmod +x scripts/*",
            "sudo sh scripts/private_ip_to_hosts_file.sh ${element(aws_instance.swarm_manager.*.private_ip, count.index + 1)}",
            "sudo sh scripts/init_node.sh"
        ]
    }
}

output "swarm_manager_public_ips" {
    value = "${concat(aws_instance.swarm_manager.*.public_ip)}"
}

output "swarm_manager_private_ips" {
    value = "${concat(aws_instance.swarm_manager.*.private_ip)}"
}

output "swarm_managers_provisioned" {
    value = "${null_resource.provision-manager-node.*.id}"
}