#!/bin/bash
CLUSTER_PUBLIC_ADDRESS=$1
TLS_DIR_PATH=$2
CLUSTER_NAME=KUBERNETES_CLUSTER

kubectl config set-cluster $CLUSTER_NAME \
  --certificate-authority=$TLS_DIR_PATH/ca.pem \
  --embed-certs=true \
  --server=https://$CLUSTER_PUBLIC_ADDRESS:6443

kubectl config set-credentials admin \
  --client-certificate=$TLS_DIR_PATH/admin.pem \
  --client-key=$TLS_DIR_PATH/admin-key.pem

kubectl config set-context $CLUSTER_NAME \
  --cluster=$CLUSTER_NAME \
  --user=admin

kubectl config use-context $CLUSTER_NAME