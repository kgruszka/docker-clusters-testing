resource "aws_instance" "slave" {
    instance_type = "${var.slave_node_instance_type}"
    ami = "${lookup(var.amis, var.region)}"
    count = "${var.slave_node_count}"
    subnet_id = "${var.subnet_id}"
    key_name = "${var.key_name}"

    vpc_security_group_ids = [
        "${var.sg_id}"
    ]

    connection {
        bastion_host = "${aws_eip.ip.0.public_ip}"
        user = "${var.cluster_user}"
        private_key = "${file("${var.cluster_private_key_path}")}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo systemctl stop docker",
            "sudo nohup dockerd -H 0.0.0.0:2375 -H unix:///var/run/docker.sock &",
            "sudo docker swarm join ${aws_instance.master.private_ip} --token $(docker -H ${aws_instance.master.private_ip} swarm join-token -q worker)"
        ]
    }

    depends_on = [
        "aws_instance.master"
    ]
}

output "slaves" {
    value = "${concat(aws_instance.slave.*.private_ip)}"
}