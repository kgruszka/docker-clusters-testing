resource "aws_instance" "slave" {
    instance_type = "${var.slave_node_instance_type}"
    ami = "${lookup(var.amis, var.region)}"
    count = "${var.slave_node_count}"
    subnet_id = "${var.subnet_id}"
    key_name = "${var.key_name}"
    associate_public_ip_address = "true"

    vpc_security_group_ids = [
        "${var.sg_id}"
    ]

    depends_on = [
        "aws_instance.master"
    ]
}

resource "null_resource" "provision-slave-node" {
    # Changes to any instance of the cluster requires re-provisioning
    triggers {
        cluster_instance_ids = "${join(",", aws_instance.slave.*.id)}"
    }
    count = "${var.slave_node_count}"

    connection {
        bastion_host = "${var.bastion_public_ip}"
        user = "${var.cluster_user}"
        host = "${element(aws_instance.slave.*.private_ip, count.index)}"
        private_key = "${file("${var.cluster_private_key_path}")}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo -u ${var.cluster_user} mkdir /home/${var.cluster_user}/scripts",
            "sudo -u ${var.cluster_user} mkdir /home/${var.cluster_user}/test"
        ]
    }

    provisioner "file" {
        source      = "${var.local_scripts_path}/"
        destination = "/home/${var.cluster_user}/scripts"
    }

    provisioner "file" {
        source      = "${var.local_test_dir_path}/"
        destination = "/home/${var.cluster_user}/test"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo chmod +x /home/${var.cluster_user}/scripts/private_ip_to_hosts_file.sh",
            "sudo /home/${var.cluster_user}/scripts/private_ip_to_hosts_file.sh '${element(aws_instance.slave.*.private_ip, count.index)}'",
            "sudo docker swarm join ${aws_instance.master.0.private_ip}:2377 --token $(docker -H ${aws_instance.master.0.private_ip} swarm join-token -q worker)",
            "sudo chmod +x /home/${var.cluster_user}/test/init.sh && sudo sh /home/${var.cluster_user}/test/init.sh",
        ]
    }
}

output "slave_public_ips" {
    value = "${concat(aws_instance.slave.*.public_ip)}"
}

output "slave_private_ips" {
    value = "${concat(aws_instance.slave.*.private_ip)}"
}