resource "aws_instance" "bastion" {
  ami = "${var.bastion_ami}"
  instance_type = "${var.bastion_instance_type}"
  key_name = "${aws_key_pair.cluster.key_name}"
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.cluster.id}"
  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}"
  ]

  tags {
    Application = "${var.app_tag}"
    ManagedBy = "Terraform",
    Role = "Kubernetes bastion"
  }
}

resource "null_resource" "bastion" {
  connection {
    host = "${aws_instance.bastion.public_ip}"
    user = "${var.bastion_user}"
    private_key = "${file(var.bastion_private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/${var.bastion_user}/scripts"
    ]
  }

  provisioner "file" {
    source = "${var.bastion_private_key_path}"
    destination = "/home/${var.bastion_user}/.ssh/docker-cluster"
  }

  provisioner "file" {
    source      = "${var.local_scripts_path}/private_ip_to_hosts_file.sh"
    destination = "/home/${var.bastion_user}/scripts/private_ip_to_hosts_file.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 600 .ssh/docker-cluster",
      "sudo chmod +x scripts/private_ip_to_hosts_file.sh",
      "sudo sh scripts/private_ip_to_hosts_file.sh '${aws_instance.bastion.private_ip}'"
    ]
  }
}

output "bastion_public_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "bastion_private_ip" {
  value = "${aws_instance.bastion.private_ip}"
}