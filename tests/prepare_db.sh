#!/bin/bash
storage_host=$1
storage_port=$2
storage_auth=$3
db_name=$4
collection_name=$5
collection_description=$6

db_exists=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Basic $storage_auth" $storage_host:$storage_port/$db_name | jq '._id')
if [ "$db_exists" != "$db_name" ] ; then 
    echo "Found db $db_exists"
    echo "Creating db $db_name"
    curl -X PUT -H "Content-Type: application/json" -H "Authorization: Basic $storage_auth" $storage_host:$storage_port/$db_name
fi

coll_exists=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Basic $storage_auth" $storage_host:$storage_port/$db_name/$collection_name | jq '._id')
if [ "$coll_exists" != "$collection_name" ] ; then
    echo "Found collection $coll_exists"
    echo "Creating collection $collection_name => $collection_description"
    curl -X PUT -H "Content-Type: application/json" -H "Authorization: Basic $storage_auth" -d "{\"desc\":\"$collection_description\"}" $storage_host:$storage_port/$db_name/$collection_name
fi