#!/usr/bin/env bash
#MONGO_HOST = ?
#MONGO_PORT = ?
#MONGO_USERNAME = ?
#MONGO_PASSWORD = ?
#for ($(ls tests) -> filter dirs : test) do
#    for ($(ls test) : config)
#        expectedResults = config.resultCount
#        terraform apply -var (from config) -var 'local_test_dir_path=tests/start_containers' -var-file='terraform.tfvars' ../
#
#        while (resultCount in Mongo == expectedResults || timeout) do
#            sleep 1000
#            resultsCount = get mongo results count
#        end
#
#        terraform destroy
#end
