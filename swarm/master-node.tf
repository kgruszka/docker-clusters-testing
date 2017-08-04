resource "aws_instance" "master" {
    instance_type = "${var.master_node_instance_type}"
    ami = "${lookup(var.amis, var.region)}"
    count = "${var.master_node_count}"
    subnet_id = "${var.subnet_id}"
    key_name = "${var.key_name}"

    vpc_security_group_ids = [
        "${var.sg_id}"
    ]
}

resource "aws_eip" "ip" {
    instance = "${element(aws_instance.master.*.id, count.index)}"
    vpc = true
    count = "${var.master_node_count}"

    connection {
        host = "${aws_eip.ip.public_ip}"
        user = "${var.cluster_user}"
        private_key = "${file("${var.cluster_private_key_path}")}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo systemctl stop docker",
            "sudo echo \"ip-${element(aws_instance.master.*.private_ip, count.index)}\" >> /etc/hosts",
            "sudo nohup dockerd -H 0.0.0.0:2375 -H unix:///var/run/docker.sock &",
            "docker swarm init"
        ]
    }
}

output "master_ip" {
    value = "${aws_eip.ip.public_ip}"
}

output "master_private_ip" {
    value = "${aws_instance.master.private_ip}"
}

output "master_dns" {
    value = "${concat(aws_instance.master.public_dns)}"
}
