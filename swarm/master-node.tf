resource "aws_instance" "master" {
    instance_type = "${var.master_node_instance_type}"
    ami = "${lookup(var.amis, var.region)}"
    count = "${var.master_node_count}"
    subnet_id = "${var.subnet_id}"
    key_name = "${var.key_name}"
    associate_public_ip_address = "true"

    vpc_security_group_ids = [
        "${var.sg_id}"
    ]
}

resource "null_resource" "provision-master-node" {
    # Changes to anys instance of the cluster requires re-provisioning
    triggers {
        cluster_instance_ids = "${join(",", aws_instance.master.*.id)}"
    }
    count = "${var.master_node_count}"

    connection {
        bastion_host = "${var.bastion_public_ip}"
        user = "${var.cluster_user}"
        host = "${element(aws_instance.master.*.private_ip, count.index)}"
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
            "sudo sh /home/${var.cluster_user}/scripts/private_ip_to_hosts_file.sh '${element(aws_instance.master.*.private_ip, count.index)}'",
            "sudo systemctl stop docker",
            "sudo nohup dockerd -H 0.0.0.0:2375 -H unix:///var/run/docker.sock &",
            "docker swarm init",
            "sudo chmod +x /home/${var.cluster_user}/test/init.sh && sudo sh /home/${var.cluster_user}/test/init.sh",
        ]
    }
}

output "master_public_ips" {
    value = "${concat(aws_instance.master.*.public_ip)}"
}

output "master_private_ips" {
    value = "${concat(aws_instance.master.*.private_ip)}"
}