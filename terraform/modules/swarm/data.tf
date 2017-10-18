data "template_file" "init_master" {
  template = "${path.module}/data/init_master.sh"
}

data "template_file" "init_manager" {
  template = "${path.module}/data/init_manager.sh"

  vars {
    SWARM_MASTER_IP = "${aws_instance.swarm_manager.0.private_ip}"
  }
}

data "template_file" "init_worker" {
  template = "${path.module}/data/init_worker.sh"

  vars {
    SWARM_MASTER_IP = "${aws_instance.swarm_manager.0.private_ip}"
  }
}