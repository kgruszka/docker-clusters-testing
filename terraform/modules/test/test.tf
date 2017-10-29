resource "null_resource" "test" {
  depends_on = [
    "null_resource.init_manager",
    "null_resource.init_worker"
  ]

  connection {
    bastion_host = "${var.bastion_public_ip}"
    host = "${var.manager_machine_ips[0]}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf test",
      "mkdir -p /home/${var.cluster_user}/test"
    ]
  }

  provisioner "file" {
    source = "${var.test_dir_path}/run/"
    destination = "/home/${var.cluster_user}/test/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash test/run.sh ${var.worker_machine_count} ${var.worker_machine_ips[0]} 3000 ${join(",", var.worker_machine_ips)}"
    ]
  }
}

resource "null_resource" "test_results" {
  depends_on = [
    "null_resource.test"
  ]

  connection {
    host = "${var.db_host_public_ip}"
    user = "${var.cluster_user}"
    private_key = "${file(var.cluster_private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "docker run --rm --network docker_backend -v /home/ubuntu/results:/results mongo sh -c 'mongoexport -h restheart-dev-mongo -d test -c ${var.test_name} -o /results/${var.test_name}.json'"
    ]
  }
//
//  provisioner "local-exec" {
//    command = "scp -i ${var.cluster_private_key_path} -oStrictHostKeyChecking=no -r ${var.cluster_user}@${var.db_host_public_ip}/home/ubuntu/log ${var.test_dir_path}/results"
//  }

  provisioner "local-exec" {
    command = "scp -i ${var.cluster_private_key_path} -oStrictHostKeyChecking=no ${var.cluster_user}@${var.db_host_public_ip}:/home/ubuntu/results/${var.test_name}.json ${var.test_dir_path}/results/"
  }
}