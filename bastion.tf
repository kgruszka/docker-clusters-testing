resource "aws_instance" "bastion" {
  instance_type = "${var.bastion_instance_type}"
  ami = "${lookup(var.amis, var.region)}"
  subnet_id = "${aws_subnet.swarm.id}"
  key_name = "${aws_key_pair.ec2-key.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.cluster.id}"
  ]
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true

  connection {
    host = "${aws_eip.bastion.public_ip}"
    user = "${var.cluster_user}"
    private_key = "${file("${var.cluster_private_key_path}")}"
  }

  provisioner "file" {
    source      = "scripts/private_ip_to_hosts_file.sh"
    destination = "/home/${var.cluster_user}/private_ip_to_hosts_file.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/${var.cluster_user}/private_ip_to_hosts_file.sh",
      "sudo sh /home/${var.cluster_user}/private_ip_to_hosts_file.sh '${aws_instance.bastion.private_ip}'",
    ]
  }
}

output "bastion_public_ip" {
  value = "${aws_eip.bastion.public_ip}"
}

output "bastion_private_ip" {
  value = "${aws_instance.bastion.private_ip}"
}

