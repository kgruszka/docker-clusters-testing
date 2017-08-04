// nodes
region = "eu-central-1"
amis = {
    "eu-central-1" = "ami-d7fb57b8"
}
master_node_count = 1
slave_node_count = 1
cluster_user = "ubuntu"
cluster_private_key_path = "ssh/docker-cluster"
master_node_instance_type = "t2.micro"
slave_node_instance_type = "t2.micro"

// subnets
availability_zone = "eu-central-1a"