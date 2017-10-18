#!/bin/sh
cd terraform
. ~/Documents/dazn/daznapi-snippets/assume_token.sh true true
terraform apply -target module.kubernetes -target module.bastion_kubectl
cd ..