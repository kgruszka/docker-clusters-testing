#!/bin/bash
cd "$(dirname "$0")"

WORKER_PUBLIC_IPS_STRING=$1
WORKER_PRIVATE_IPS_STRING=$2
MANAGER_PUBLIC_IPS_STRING=$3
MANAGER_PRIVATE_IPS_STRING=$4
MANAGER_PUBLIC_ADDRESS=$5
MANAGER_SERVICE_IPS_STRING="10.32.0.1"
CLUSTER_NAME=KUBERNETES_CLUSTER
DESTINATION_DIR=generated
IFS=', ' read -r -a WORKER_PUBLIC_IPS <<< "$WORKER_PUBLIC_IPS_STRING"
IFS=', ' read -r -a WORKER_PRIVATE_IPS <<< "$WORKER_PRIVATE_IPS_STRING"
WORKER_COUNT=${#WORKER_PUBLIC_IPS[@]}

# Create a private key called (ca-priv-key.pem)
openssl genrsa -out $DESTINATION_DIR/ca-priv-key.pem 2048

# Create a public key called ca.pem for the CA (ca.pem)
openssl req -config /usr/lib/ssl/openssl.cnf -new -key ca-priv-key.pem -x509 -days 1825 -out ca.pem

# iterate through all managers and workers
# Create a private key swarm-priv-key.pem for Swarm Manager (swarm-priv-key.pem)
openssl genrsa -out swarm-priv-key.pem 2048

# Generate a certificate signing request (CSR) swarm.csr using the private key created in the previous step (swarm.csr)
openssl req -subj "/CN=swarm" -new -key swarm-priv-key.pem -out swarm.csr

# Create the certificate swarm-cert.pem based on the CSR created in the previous step.
openssl x509 -req -days 1825 -in swarm.csr -CA ca.pem -CAkey ca-priv-key.pem -CAcreateserial -out swarm-cert.pem -extensions v3_req -extfile /usr/lib/ssl/openssl.cnf

# https://github.com/docker/docker.github.io/blob/master/swarm/configure-tls.md#step-4-install-the-keys