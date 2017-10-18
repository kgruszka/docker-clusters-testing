resource "aws_instance" "db_service" {
  ami = "${var.docker_ami}"
  instance_type = "t2.micro"
  key_name = "${var.ec2-key-name}"
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    "${aws_security_group.db_service.id}"
  ]
}

resource "null_resource" "db_service" {
  depends_on = ["aws_instance.db_service"]

  connection {
    host = "${aws_instance.db_service.public_ip}"
    user = "ubuntu"
    private_key = "${file(var.ec2-private-key)}"
  }

  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/SoftInstigate/restheart.git",
      "cd restheart/Docker",
      // "docker-compose up -d"
    ]
  }
}

output "public_ip" {
  value = "${aws_instance.db_service.public_ip}"
}