resource "aws_route" "kubernetes_pods_routing" {
  count = "${var.worker_count}"
  route_table_id = "${var.kubernetes_route_table_id}"
  destination_cidr_block = "10.200.${count.index}.0/24"
  instance_id = "${element(aws_instance.kubernetes_worker.*.id, count.index)}"
}