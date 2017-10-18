resource "aws_instance" "bastion" {
  instance_type = "${var.bastion_instance_type}"
  ami = "${var.bastion_ami}"
  subnet_id = "${aws_subnet.swarm.id}"
  key_name = "${aws_key_pair.ec2-key.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}"
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

  // for debugging
  provisioner "file" {
    source = "${var.cluster_private_key_path}",
    destination = "/home/${var.cluster_user}/.ssh/docker-cluster"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo -u ${var.cluster_user} chmod 600 /home/${var.cluster_user}/.ssh/docker-cluster",
      "sudo -u ${var.cluster_user} mkdir /home/${var.cluster_user}/scripts"
    ]
  }

  provisioner "file" {
    source      = "${var.local_scripts_path}/private_ip_to_hosts_file.sh"
    destination = "/home/${var.cluster_user}/scripts/private_ip_to_hosts_file.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/${var.cluster_user}/scripts/private_ip_to_hosts_file.sh",
      "sudo sh /home/${var.cluster_user}/scripts/private_ip_to_hosts_file.sh '${aws_instance.bastion.private_ip}'",
    ]
  }
}

output "bastion_public_ip" {
  value = "${aws_eip.bastion.public_ip}"
}

output "bastion_private_ip" {
  value = "${aws_instance.bastion.private_ip}"
}

