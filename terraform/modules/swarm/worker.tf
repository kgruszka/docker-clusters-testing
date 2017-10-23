resource "aws_instance" "swarm_worker" {
    instance_type = "${var.slave_node_instance_type}"
    ami = "${var.worker_ami}"
    count = "${var.slave_node_count}"
    subnet_id = "${var.subnet_id}"
    key_name = "${var.cluster_key_name}"
    associate_public_ip_address = "true"

    vpc_security_group_ids = [
        "${aws_security_group.swarm_worker.id}"
    ]

    depends_on = [
        "aws_instance.swarm_manager"
    ]
}

resource "null_resource" "provision-worker-node" {
    depends_on = [
        "null_resource.provision-master-node"
    ]

    triggers {
        cluster_instance_ids = "${join(",", aws_instance.swarm_worker.*.id)}"
    }
    count = "${var.slave_node_count}"

    connection {
        bastion_host = "${var.bastion_public_ip}"
        user = "${var.cluster_user}"
        host = "${element(aws_instance.swarm_worker.*.private_ip, count.index)}"
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
        content     = "${data.template_file.init_worker.rendered}"
        destination = "/home/${var.cluster_user}/scripts/init_node.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo chmod +x scripts/*",
            "sudo sh scripts/private_ip_to_hosts_file.sh '${element(aws_instance.swarm_worker.*.private_ip, count.index)}'",
            "sudo sh scripts/init_node.sh"
        ]
    }
}

output "swarm_worker_public_ips" {
    value = "${concat(aws_instance.swarm_worker.*.public_ip)}"
}

output "swarm_worker_private_ips" {
    value = "${concat(aws_instance.swarm_worker.*.private_ip)}"
}

output "swarm_workers_provisioned" {
    value = "${null_resource.provision-worker-node.*.id}"
}