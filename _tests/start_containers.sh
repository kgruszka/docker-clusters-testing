#!/bin/bash
master_nodes=$1
slave_nodes=$2
containers_count=$3
storage_host=$4
storage_port=$5
storage_auth=$6
DEBUG=$7

db_name="start-containers"
collection_name=$(date +%s%N)
collection_description="masters: $master_nodes, slaves: $slave_nodes, containers: $containers_count"
storage_path="/$db_name/$collection_name"
test_dir="../tests/start_containers"

echo "Preparing db ..."
sh ./tests/prepare_db.sh "$storage_host" "$storage_port" "$storage_auth" "$db_name" "$collection_name" "$collection_description"

echo "Creating cluster ..."
. ./export_aws.sh
cd terraform
TF_VAR_local_test_dir_path=$test_dir TF_VAR_storage_path=$storage_path TF_VAR_master_node_count=$master_nodes TF_VAR_slave_node_count=$slave_nodes TF_VAR_containers_count=$containers_count terraform apply -target=module.swarm
cd ../.

results_count="0"
iter=0
while [ $results_count -le $containers_count ] && [ $iter -lt 10 ] ; do 
  sleep 5
  iter=$(($iter + 1))
  results_count=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Basic $storage_auth" $storage_host:$storage_port/$db_name/$collection_name?count | jq '._size')
  echo "iteration: $iter"
  echo "results: $results_count"
done

if [ -z "$DEBUG" ] ; then
  echo "Deleting cluster ..."
  cd terraform
  TF_VAR_storage_path=$storage_path TF_VAR_master_node_count=$master_nodes TF_VAR_slave_node_count=$slave_nodes TF_VAR_containers_count=$containers_count terraform destroy -force -target=module.swarm
  cd ../.
fi

echo "Test finished ..."