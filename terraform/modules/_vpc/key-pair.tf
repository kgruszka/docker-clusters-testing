resource "aws_key_pair" "ec2-key" {
  key_name_prefix = "${var.ec2-key["prefix"]}"
  public_key = "${var.ec2-key["public_key"]}"
}

output "ec2-key-name" {
  value = "${aws_key_pair.ec2-key.key_name}"
}