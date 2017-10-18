//resource "null_resource" "test" {
//  connection {
//    bastion_host = "${var.bastion_public_ip}"
//    user = "${var.cluster_user}"
//    host = "${aws_instance.swarm_manager.0.private_ip}"
//    private_key = "${file("${var.cluster_private_key_path}")}"
//  }
//
//  provisioner "remote-exec" {
//    inline = [
//      "sudo chmod +x /home/${var.cluster_user}/test/*",
//      "sudo sh /home/${var.cluster_user}/test/test.sh 172.17.0.1 3000 ${var.containers_count}"
//    ]
//  }
//
//  depends_on = [
//    "aws_instance.swarm_worker",
//    "aws_instance.swarm_manager",
//    "null_resource.provision-master-node",
//    "null_resource.provision-worker-node",
//    "null_resource.provision-manager-node"
//  ]
//}