cd terraform
. ~/Documents/dazn/daznapi-snippets/assume_token.sh true true
terraform apply -target module.vpc
cd ..