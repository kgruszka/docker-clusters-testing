resource "aws_key_pair" "cluster" {
  public_key = "${var.cluster_public_key}"
  key_name = "${var.app_tag}_cluster_key"
}

output "cluster-key-name" {
  value = "${aws_key_pair.cluster.key_name}"
}