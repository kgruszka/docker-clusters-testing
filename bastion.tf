resource "aws_instance" "bastion" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.bastion_instance_type}"

  subnet_id = "${aws_subnet.swarm.id}"

  key_name = "${aws_key_pair.ec2-key.key_name}"

  vpc_security_group_ids = [
    "${aws_vpc.clusters.id}"
  ]
}