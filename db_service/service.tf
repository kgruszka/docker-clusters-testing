variable "docker_ami" {
  default = "ami-01c36b6e"
}

resource "aws_instance" "db_service" {
  ami = "${var.docker_ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.db_service.key_name}"
  subnet_id = "${aws_subnet.db_service.id}"

  vpc_security_group_ids = [
    "${aws_security_group.db_service.id}"
  ]
}

resource "aws_eip" "db_service" {
  instance = "${aws_instance.db_service.id}"
  vpc = true

  connection {
    host = "${aws_eip.db_service.public_ip}"
    user = "ubuntu"
    private_key = "${file("ssh/docker-cluster")}"
  }

  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/SoftInstigate/restheart.git",
      "cd restheart/Docker",
      "docker-compose up -d"
    ]
  }
}

output "public_ip" {
  value = "${aws_instance.db_service.public_ip}"
}